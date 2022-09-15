import ArgumentParser
import Foundation
import OpenAIAPI

extension Files.Upload.Purpose: ExpressibleByArgument {}

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
    
    let files = try await client.call(Files.List())
        
    print(title: "Files:", format: config.format())
    print(list: files.data.sorted(by: { $0.id.value < $1.id.value }), format: config.format(), with: print(file:format:))
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
    
    print(title: "File Detail", format: config.format())
    print(file: result, format: config.format())
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
    print(title: "File Detail", format: config.format())
    print(file: file, format: config.format())
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
      print(label: "File Saved:", value: output, format: config.format())
    } else {
      print(label: "File Name", value: result.filename, format: config.format())
      let outputString = String(data: result.data, encoding: .utf8)
      guard let outputString = outputString else {
        throw AppError("Unable to decode data file as UTF-8: \(fileId)")
      }
      print(subtitle: "File Content:", format: config.format())
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
    
    print(label: "File ID", value: result.id, format: config.format())
    print(label: "Deleted", value: result.deleted ? "yes" : "no", format: config.format())
  }
}
