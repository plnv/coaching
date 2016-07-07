require 'example_user'


describe 'User' do

  subject(:user) { User.new(name: 'asd zxc', email: 'asd@asd.com') }

  it '.formatted_email expect returns formatted email' do
    expect(user.formatted_email).to eq('asd zxc <asd@asd.com>')
  end

  it '.full_name expect returns the first and last names separated by a space' do
    expect(user.full_name).to eq('asd zxc')
  end

  it '.alphabetical_name expect returns the last name and first name separated by comma-space' do
    expect(user.alphabetical_name).to eq('zxc, asd')
  end

  it 'expect that full_name.split is the same as alphabetical_name.split(’, ’).reverse' do
    expect(user.full_name.split).to eq(user.alphabetical_name.split(', ').reverse)
  end

end