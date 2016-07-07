class User
  attr_accessor :name, :email

  def initialize(attributes = {})
    @name  = attributes[:name]
    @email = attributes[:email]
  end

  def formatted_email
    "#{@name} <#{@email}>"
  end

  def full_name
    @arr = @name.split(" ")
    "#{@arr[0]} #{@arr[1]}"
  end

  def alphabetical_name
    @arr = @name.split(" ")
    "#{@arr[1]}, #{@arr[0]}"
  end

  def check
    full_name.split == alphabetical_name.split(', ').reverse
  end
end