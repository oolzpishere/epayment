# Epayment
Short description and motivation.



## Installation
Add this line to your application's Gemfile:

```ruby
gem 'epayment', :github => 'oolzpishere/epayment'
```

And then execute:
```bash
$ bundle
```


## Usage
How to use my plugin.

### Config

Create `config/initializers/epayment.rb` and put following configurations into it.

```ruby
# required
Epayment.wechat_payment_model = "your model class name"
# wechat pay notify_url
Epayment.wechat_pay_notify_url = 'your_host/wechat_payment_notify'

```



## Contributing
Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
