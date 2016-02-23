# lita-regex

show pattern matched text

## Installation

Add lita-regex to your Lita instance's Gemfile:

``` ruby
gem "lita-regex", github: 'mayok/lita-regex'
```

## Configuration

### Required attributes

* `channel_name` (String) - channel name

### Example

``` ruby
Lita.configure do |config|
  config.robot.adapter = :slack
  config.handlers.regex.channel_name = "general"
end
```

## Usage

`curl -d "TEXT PATTERN COUNT" APP_URL`

## License

[MIT](http://opensource.org/licenses/MIT)
