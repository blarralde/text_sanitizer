## OLD BAD CODE, PLEASE DON'T USE

# TextSanitizer

I found myself repeating the same text formatting methods over multiple models
and realized this wasn't dry, so I made a plugin.

This plugin is useful if you:

* have (untrusted) users create objects with text fields on your website
* like to have consistently formatted data in your DB
* are going to display the text fields as is (or with .html_safe) in your app and want to make it safer (this uses the [Sanitize](https://github.com/rgrove/sanitize) gem by Ryan Grove)

## How to use

Install as a gem with:

```ruby
gem 'text_sanitizer'
```

In the model where you want to format data:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :name, :body, :email
  sanitize_text :body
  downcase_text :email
  capitalize_text :name
end
```

This will convert:

* sanitize_text: `<script>body!</script>` into `body!`
* downcase_text: `EMAIL@TEST.COM` into `email@test.com`
* capitalize_text: `john SMITH` into `John Smith`

## Custom sanitizers

You can also add your own sanitizers. To do so, use the following syntax in your model:

```ruby
register_sanitizer :method, :callback
```

So for instance, to add a sanitizer called upcase:

```ruby
register_sanitizer :upcase, :before_save
upcase_text :title, :name

private
def upcase text
  text.upcase
end
```

Or you can also use the shorthand:

```ruby
register_sanitizer :upcase, :before_save, :title, :name
```

This is basically equivalent to having the following in your model:

```ruby
before_save :upcase_text

def upcase_text
  [:name, :title].each do |text_field|
    self.send "#{text_field}#", read_attribute(text_field).upcase
  end
end
```

You should consider whether the saving in verbose is worth it for you.
It should be if you repeat this pattern often.

If you want to be able to use your new sanitizer in all models, create a new file
in lib/ and paste the following:

```ruby
register_sanitizer :upcase, :before_save

private
def upcase text
  text.upcase
end
```

Now you'll just need to call `upcase_text :title` from your model.
