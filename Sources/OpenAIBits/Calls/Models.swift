/// List and describe the various ``Model``s available in the API. You can refer to the [Models documentation](https://platform.openai.com/docs/models) to understand what models are available and the differences between them.
///
/// ## Calls
///
/// - ``Models/List`` - Lists all available ``Model``s.
/// - ``Models/Detail`` - Retrieves details for a single ``Model``.
/// - ``Models/Delete`` - Deletes a ``Model`` you own.
///
/// ## See Also
///
/// - [OpenAI API](https://platform.openai.com/docs/api-reference/models)
/// - [Models documentation](https://platform.openai.com/docs/models)
public enum Models {}

// MARK: List

extension Models {
  /// A ``Call`` that lists the currently available ``Model``s, and provides basic information about each one such as the owner and availability.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://platform.openai.com/docs/api-reference/models/list)
  public struct List: GetCall {
    /// Response with a ``ListOf`` ``Model``s.
    public typealias Response = ListOf<Model>
    
    var path: String { "models" }
    
    /// Constructs the ``Models/List`` call.
    public init() {}
  }
}

// MARK: Detail

extension Models { 
  /// A ``Call`` that retrieves a ``Model`` instance, providing basic information about the ``Model`` such as the owner and permissioning.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://platform.openai.com/docs/api-reference/models/retrieve)
  public struct Detail: GetCall {
    /// Responds with a ``Model``.
    public typealias Response = Model
    
    var path: String { "models/\(id.value)"}
    
    /// The ``Model/ID-swift.struct``.
    public let id: Model.ID
    
    /// Constructs ``Models`` ``Models/Detail`` with the specified ``Model/ID-swift.struct``.
    ///
    /// - Parameter id: The ``Model`` `ID`.
    public init(id: Model.ID) {
      self.id = id
    }
  }
}

// MARK: Delete

extension Models {
  /// A ``Call`` to delete a ``Model``. You must have the `Owner` role in your organization, usually ``FineTune`` models.
  ///
  /// ## See Also
  ///
  /// - [OpenAI API](https://platform.openai.com/docs/api-reference/fine-tunes/delete-model)
  public struct Delete: DeleteCall {
    /// The HTTP call path.
    var path: String { "models/\(id)" }
    
    /// The ``FineTunes/Delete`` `Response`.
    public struct Response: JSONResponse {
      /// The ``Model/ID-swift.struct`` for the fine-tuned ``Model`` that was deleted.
      public let id: Model.ID

      /// Indicates if it was deleted.
      public let deleted: Bool
      
      /// The ``FineTunes/Delete`` `Response`.
      ///
      /// - Parameter id: The ``Model/ID-swift.struct`` for the fine-tuned ``Model`` that was deleted.
      /// - Parameter deleted: Indicates if it was deleted.
      public init(id: Model.ID, deleted: Bool) {
        self.id = id
        self.deleted = deleted
      }
    }
    
    /// The ``Model/ID-swift.struct`` to delete.
    public let id: Model.ID
    

    /// Delete a fine-tuned model. You must have the `Owner` role in your organization.
    ///
    /// - Parameter id: The ``Model/ID-swift.struct`` to delete.
    public init(id: Model.ID) {
      self.id = id
    }
  }
}
