require 'rubygems'
require 'selenium-webdriver'
require 'io/console'

profiles = %w[

  https://www.linkedin.com/in/aaron-strauli-1a6883a2/
  https://www.linkedin.com/in/aahmad94/
  https://www.linkedin.com/in/alexander-marks-katz/
  https://www.linkedin.com/in/ajamesdelossantos/
  https://www.linkedin.com/in/ameetvadhia/
  https://www.linkedin.com/in/angelica-velasco/
  https://www.linkedin.com/in/annanoh/
  https://www.linkedin.com/in/artem-kharshan/
  https://www.linkedin.com/in/ashvalejohn/
  https://www.linkedin.com/in/bo-pang-83a321154/
  https://www.linkedin.com/in/bmsheets/
  https://www.linkedin.com/in/brillantewang/
  https://www.linkedin.com/in/christina-kiesz-66a513a3/
  https://www.linkedin.com/in/cdisong/
  https://www.linkedin.com/in/chbigelow/
  https://www.linkedin.com/in/cynthiama/
  https://www.linkedin.com/in/david-bodow-46375053/
  https://www.linkedin.com/in/don-kim-ab961213a/
  https://www.linkedin.com/in/edan-lewis-752633133/
  https://www.linkedin.com/in/edwardjbai/
  https://www.linkedin.com/in/ethan-bjornsen-64a40b149/
  https://www.linkedin.com/in/francis-lara/
  https://www.linkedin.com/in/garrett-tongue-011286138/
  https://www.linkedin.com/in/guy-wassather-678740b7/
  https://www.linkedin.com/in/henrychen11/
  https://www.linkedin.com/in/andrew-cho-64b082155/
  https://www.linkedin.com/in/jacwutang/
  https://www.linkedin.com/in/jacob-butler-a2ab7093/
  https://www.linkedin.com/in/jay-schwartz/
  https://www.linkedin.com/in/jeffrey-chuc/
  https://www.linkedin.com/in/jeffrey-ren/
  https://www.linkedin.com/in/jonathan-ray/
  https://www.linkedin.com/in/joey-doyle-25971189/
  https://www.linkedin.com/in/josh-earlenbaugh-phd-b53770aa/
  https://www.linkedin.com/in/julian-compagni-portis-b52005b0/
  https://www.linkedin.com/in/julien-gurunlian-7b5a985a/
  https://www.linkedin.com/in/kevin-silberblatt-478aa3154/
  https://www.linkedin.com/in/kylehchen/
  https://www.linkedin.com/in/kirbyneaton/
  https://www.linkedin.com/in/linda-cyl/
  https://www.linkedin.com/in/bucknermr/
  https://www.linkedin.com/in/matthew-hu-4a85752a/
  https://www.linkedin.com/in/mattjsperry/
  https://www.linkedin.com/in/maxinechui/
  https://www.linkedin.com/in/mike-salisbury-4116b74b/
  https://www.linkedin.com/in/miles-mcleod/
  https://www.linkedin.com/in/niallmahford/
  https://www.linkedin.com/in/nwilliams770/
  https://www.linkedin.com/in/omardls/
  https://www.linkedin.com/in/patrick-conde-69815b68/
  https://www.linkedin.com/in/qiumin-yin/
  https://www.linkedin.com/in/reidsherman/
  https://www.linkedin.com/in/ryan-mease-140b473a/
  https://www.linkedin.com/in/taylor-reed-wong/
  https://www.linkedin.com/in/mrthomasmvu/
  https://www.linkedin.com/in/trungvuh/
  https://www.linkedin.com/in/truong-nguyen-2821471b/
  https://www.linkedin.com/in/tyler-chi/
  https://www.linkedin.com/in/vickie-chen/
  https://www.linkedin.com/in/william-meng-74039a11/
  https://www.linkedin.com/in/wilson-chun/
  https://www.linkedin.com/in/lily-yang-04105425/
]

if ARGV[0] == "-f" || ARGV[0] == "--firefox"
  driver = Selenium::WebDriver.for :firefox
else
  driver = Selenium::WebDriver.for :chrome
end

puts "please enter your linkedin email: "
user_email = gets.chomp
puts "please enter your linked in password (don't worry it wont be saved anywhere): "
user_password = STDIN.noecho(&:gets).chomp
puts "would you like to send connect invites users you are not yet connected with? (y/n): "
response = gets.chomp
send_connect = response.include?("y")
puts "Endorse-o-matic 3000 is starting now. This proccess should take about 5 minutes :)"

# If you are getting a timeout error you can try increasing timout value
wait = Selenium::WebDriver::Wait.new(timeout: 3)

driver.get "https://www.linkedin.com/"
email = nil
wait.until do
  email = driver.find_element(:id, "login-email")
  true
end
password = nil
wait.until do
  password = driver.find_element(:id, "login-password")
  true
end


email.send_keys(user_email)
password.send_keys(user_password)
driver.find_element(:id, "login-submit").click

profiles.each do |profile|
  driver.get profile

  (0...5000).step(100) do |i|
    driver.execute_script("scroll(0,#{i})")
  end

  begin
    wait.until { driver.find_element(:class, "pv-skills-section__additional-skills") }
  rescue => exception
    name = /[\(\d\)\s]?([a-zA-Z ]+)/.match(driver.title)[1]
    puts "Can't find skills to endorse for #{name}"
    next
  end

  begin
    connect_btn = driver.find_element(:class, "pv-s-profile-actions--connect")
  rescue => exception
    connect_btn = nil
  end
  name = /[\(\d\)\s]?([a-zA-Z ]+)/.match(driver.title)[1]
  if connect_btn
    puts "not yet connected with " + name
    if send_connect
      connect_js = "document.querySelector('.pv-s-profile-actions--connect').click()"
      driver.execute_script(connect_js)
      sleep(0.25)
      modal = driver.find_element(:class, "send-invite__actions")
      modal.find_element(:class, "button-primary-large").click
      puts "sent connection invite"
    end
    next
  end

  endorse_js = "document.querySelector('.pv-skills-section__additional-skills').click();
                Array.from(document.getElementsByClassName('pv-skill-entity__featured-endorse-button-shared button-secondary-medium-round')).forEach(el => el.click());"

  driver.execute_script(endorse_js)
  puts "done endorsing #{name}"
end
driver.quit
