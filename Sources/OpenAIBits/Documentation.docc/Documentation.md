# ``OpenAIBits``

A Swift library to interact with the OpenAI public API.

## Overview

[OpenAI](https://openai.com) provides a [public API](https://beta.openai.com/docs/introduction) to interact with its machine learning models: GPT-3 (for text) and DALL-E (for images).

This library provides a Swift-native way of calling the API using `async/await`, so requires being compiled with Swift 5.6+.

Best efforts are done to keep it up-to-date with the full API. Class, function and variable names generally follow the conventions of the API, with some modifications made where the API is inconsistent (eg. where the "creation date" is sometimes `created` and sometimes `createdAt`, this library uses `created` for all of them.)

## Topics

### OpenAI Client

The ``OpenAI`` struct configures your connection to OpenAI. After initialisation, you pass it a ``Call`` to perform an operation.

- ``OpenAI``
- ``Call``

### Text (GPT-3)

OpenAI provides several tools for generating text predictions based on a prompt. This uses their **GPT-3** models, which have different levels of complexity and cost to execute.

- ``Completions``
- ``Edits``
- ``Embeddings``
- ``Moderations`` 

### Images (DALL-E)

Another popular tool is **DALL-E**, which takes a text prompt and creates a new image. It also has the ability to edit existing images and create variations of an image.

- ``Images``

### Other Calls

There are also some utility calls available, which provide extra information or facilities for tuning your use of the API.

- ``Files``
- ``FineTunes``
- ``Models``
- ``Tokens``

### Values

The calls above result in response values. Some of these are also used as parameters when creating a ``Call`` type.

- ``BinaryData``
- ``Completion``
- ``Edit``
- ``Embedding``
- ``File``
- ``FineTune``
- ``Generations``
- ``Identifier``
- ``ListOf``
- ``Logprobs``
- ``Model``
- ``Moderation``
- ``Penalty``
- ``Percentage``
- ``Prompt``
- ``Token``
- ``Usage``

### Utility Classes

- ``TokenEncoder``
