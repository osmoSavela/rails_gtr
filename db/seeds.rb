# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Membership.destroy_all

memberships = Membership.create([{
	name: 'Platinum',
	description: '',
	monthly_price: 99.99,
	annual_price: 1000,
	hex_color: '#f6f6f6',
	range_hours: 50,
	training_discount: 20,
	range_ammo_discount: 10,
	accessory_discount: 20,
	private_instructor_discount: 20,
	annual_guest_passes: 12,
	lounge_access: true
},
{
	name: 'Gold',
	description: '',
	monthly_price: 74.99,
	annual_price: 750,
	hex_color: 'gold',
	range_hours: 30,
	training_discount: 15,
	range_ammo_discount: 10,
	accessory_discount: 15,
	private_instructor_discount: 15,
	annual_guest_passes: 8,
	lounge_access: true
},
{
	name: 'Silver',
	description: '',
	monthly_price: 62.50,
	annual_price: 625,
	hex_color: 'silver',
	range_hours: 20,
	training_discount: 15,
	range_ammo_discount: 10,
	accessory_discount: 10,
	private_instructor_discount: 10,
	annual_guest_passes: 6,
	lounge_access: true
},
{
	name: 'Individual',
	description: '',
	monthly_price: 44.99,
	annual_price: 449,
	hex_color: '#7ED321',
	range_hours: 10,
	training_discount: 10,
	range_ammo_discount: 5,
	accessory_discount: 5,
	private_instructor_discount: 0,
	annual_guest_passes: 2,
	lounge_access: true
},
{
	name: 'Family',
	description: '',
	monthly_price: 62.50,
	annual_price: 625,
	hex_color: '#E95125',
	range_hours: 10,
	training_discount: 10,
	range_ammo_discount: 5,
	accessory_discount: 5,
	private_instructor_discount: 0,
	annual_guest_passes: 4,
	lounge_access: true
},
{
	name: 'Patriotic',
	description: '',
	monthly_price: 19.95,
	annual_price: 199.95,
	hex_color: '#1aa55a',
	range_hours: 10,
	training_discount: 0,
	range_ammo_discount: 10,
	accessory_discount: 0,
	private_instructor_discount: 0,
	annual_guest_passes: 12,
	lounge_access: true
},
{
	name: 'Corporate',
	description: '',
	monthly_price: 625,
	annual_price: 6250,
	hex_color: '#CB205F',
	range_hours: 100,
	training_discount: 10,
	range_ammo_discount: 0,
	accessory_discount: 0,
	private_instructor_discount: 10,
	annual_guest_passes: 25,
	lounge_access: true
}
	])


puts "created #{Membership.count} memberships"
