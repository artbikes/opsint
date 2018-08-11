describe package('nginx') do
  it { should be_installed }
end

describe package('ruby') do
  it { should be_installed }
end

describe package('htop') do
  it { should be_installed }
end

describe service('nginx') do
  it { should_not be_running }
end

describe file('/swapfile') do
  its('size') { should > 4_000_000_000 }
end

describe file('/etc/nginx/sites-available/web-app.conf') do
  its(:content) { should match(/<<<<<<< HEAD:mergetest/) }
end

describe file('/usr/share/nginx/html/index.html') do
  it { should exist }
end

describe service('api') do
  it { should be_running }
end

describe file('/etc/ssh/sshd_config') do
  its(:content) { should match(/PasswordAuthentication yes/) }
end

describe file('/home/ubuntu/access.log') do
  its(:content) { should match(/MyUserAgent/) }
end

describe file('/var/log/syslog') do
  its(:content) { should match(/BONGOMIPS/)}
end

describe file('/var/log/syslog') do
  its(:content) { should match(/BINGOMIPS/)}
end

describe file('/home/ubuntu/is_load_high.py') do
  it { should exist }
end

today = "/var/log/api/api-#{Time.at(Time.now.to_i).strftime("%Y-%m-%d")}.log"
describe file(today) do
  it { should exist}
end

yesterday = "/var/log/api/api-#{Time.at(Time.now.to_i - 86400).strftime("%Y-%m-%d")}.log"
describe file(yesterday) do
  it { should exist}
end