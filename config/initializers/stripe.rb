if Rails.env.production?
	Stripe.api_key = "sk_live_QiYpGlJ0YRGOGEJGGy4gEpeJ"
	STRIPE_PUBLIC_KEY = "pk_live_4B1BFYQmV1DjSxzhf4l1d64c"
else
	Stripe.api_key = "sk_test_GioPlRaT2nnZwHXJiLhZLr2s"
	STRIPE_PUBLIC_KEY = "pk_test_ajWRlR1sZIZNc7tp08ZLP8X5"
end
