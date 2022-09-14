import ArgumentParser
import Foundation
import OpenAIAPI

extension Files.Upload.Purpose: ExpressibleByArgument {}

func printFile(_ file: File) {
  var output = """
  ID: \(file.id)
  Bytes: \(file.bytes)
  Created At: \(file.createdAt)
  Filename: \(file.filename)
  Purpose: \(file.purpose)
  """
  
  if let status = file.status {
    output.append("\nStatus: \(status)")
  }
  if let statusDetails = file.statusDetails {
    output.append("\nStatus Details: \(statusDetails)")
  }
  
  print(output)
}

extension File.ID: ExpressibleByArgument {
  public init(argument: String) {
    self.init(argument)
  }
}

struct FilesCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "files",
    abstract: "Commands relating to listing, uploading, and managing files.",
    subcommands: [
      FilesListCommand.self,
      FilesDetailCommand.self,
      FilesUploadCommand.self,
      FilesDownloadCommand.self,
      FilesDeleteCommand.self,
    ]
  )
}

struct FilesListCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "list",
    abstract: "List available files."
  )
  
  @OptionGroup var config: Config
  
  mutating func run() async throws {
    let client = config.client()
    
    let files = try await client.call(Files.List()).data
        
    print("Files:")
    for file in files.sorted(by: { $0.id.value < $1.id.value }) {
      print("")
      printFile(file)
    }
  }
}

struct FilesUploadCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "upload",
    abstract: "Uploads a file with a specified purpose."
  )
  
  @OptionGroup var config: Config
  
  @Option(name: .shortAndLong, help: "The file to upload.", completion: .file())
  var input: String
  
  @Option(name: .long, help: "The purpose for the file. Use 'fine-tune' for fine-tuning .jsonl files.")
  var purpose: Files.Upload.Purpose
  
  mutating func run() async throws {
    let client = config.client()
    
    let fileURL = URL(fileURLWithPath: input)
    
    let result = try await client.call(Files.Upload(purpose: purpose, file: fileURL))
    
    print("File Detail:")
    printFile(result)
  }
}

struct FilesDetailCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "detail",
    abstract: "Outputs details for a file with a specific ID."
  )
  
  @OptionGroup var config: Config
  
  @Option(name: [.customLong("id"), .long], help: "The file ID.")
  var fileId: File.ID
  
  mutating func run() async throws {
    let client = config.client()

    let file = try await client.call(Files.Details(id: fileId))
    print("File Detail:")
    printFile(file)
  }
}

struct FilesDownloadCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "download",
    abstract: "Downloads a file with a specific ID."
  )
  
  @OptionGroup var config: Config
  
  @Option(name: [.customLong("id"), .long], help: "The file ID.")
  var fileId: File.ID
  
  @Option(name: .shortAndLong, help: "The name of the output file. Outputs to stdout by default.", completion: .file())
  var output: String?
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(Files.Content(id: fileId))
    
    if let output = output {
      let outputURL = URL(fileURLWithPath: output)
      try result.data.write(to: outputURL)
      print("File saved to '\(output)'.")
    } else {
      let outputString = String(data: result.data, encoding: .utf8)
      guard let outputString = outputString else {
        print("Error: Unable to process data file.")
        return
      }
      if let filename = result.filename {
        print("File Name: \(filename)")
      }
      print("File Content:")
      print(outputString)
    }
  }
}

struct FilesDeleteCommand: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "delete",
    abstract: "Deletes an uploaded file permanently."
  )
  
  @OptionGroup var config: Config
  
  @Option(name: [.customLong("id"), .long], help: "The file ID.")
  var fileId: File.ID
  
  mutating func run() async throws {
    let client = config.client()
    
    let result = try await client.call(Files.Delete(id: fileId))
    
    print("File ID: \(result.id)")
    print("Deleted: \(result.deleted ? "yes" : "no")")
  }
}
