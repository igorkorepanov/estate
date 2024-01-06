# Estate Gem

Estate is a Ruby gem designed to simplify state management in ActiveRecord models. The primary focus of this gem is to provide a straightforward way to define states and transitions using a clean syntax, allowing seamless integration into ActiveRecord models.

## Installation

Add this line to your application's Gemfile and run `bundle install`:

```ruby
gem 'estate'
```

Or install it manually using:

```bash
gem install estate
```

## Usage

To use the Estate gem, include it in your ActiveRecord model and define your states and transitions inside a block using the `estate` method. Here's a simple example:

```ruby
class MyModel < ApplicationRecord
  include Estate

  estate do
    state :state_1
    state :state_2
    state :state_3

    transition from: :state_1, to: :state_2
    transition from: :state_2, to: :state_3
    transition from: :state_3, to: :state_1
  end
end
```

The default field for storing the state is named state. You can customize this field by providing options to the estate method:

```ruby
class MyModel < ApplicationRecord
  include Estate

  estate(column: :custom_state_field, empty_initial_state: true) do
    state :state_1
    state :state_2
    state :state_3

    transition from: :state_1, to: :state_2
    transition from: :state_2, to: :state_3
    transition from: :state_3, to: :state_1
  end
end
```

## Migration Example

```bash
bundle exec rails generate migration AddStateToMyModels state:string
```

This will generate a migration file. Open the migration file and modify it to suit your needs, for example:

```ruby
class AddStateToMyModels < ActiveRecord::Migration[7.0]
  def change
    add_column :my_models, :state, :string
  end
end
```

Run the migration:

```bash
bundle exec rails db:migrate
```

## License

Copyright (c) 2023-2024 Igor Korepanov

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.