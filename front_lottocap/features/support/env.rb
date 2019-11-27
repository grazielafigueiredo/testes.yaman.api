require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec/matchers'
require 'rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'cpf_utils'
require 'faker'
require 'cielo/api30'
require 'version'

World(Capybara::DSL)
World(Capybara::RSpecMatchers)

# Selenium::WebDriver::Chrome.driver_path = 'C:\Users\Graziela\Downloads\primeiro_projeto\chromedriver_win32\chromedriver'

Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.native_events = true
    Capybara::Selenium::Driver.new(
        app, 
        :browser => :firefox, profile: profile
        )
    Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
            'chromeOptions' => {'args' => [
                '--disable-infobars','window-size=1600,1024'
                ]}
        )
    )
end

Capybara.configure do |config|
    config.default_driver = :selenium
    config.default_max_wait_time = 10
    config.app_host = 'https://homolog.lottocap.com.br'
end


