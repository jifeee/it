# Be sure to restart your server when you modify this file.


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")

Instatrace::Application.config.session_store :active_record_store


# Instatrace::Application.config.session_store :cookie_store
# Instatrace::Application.config.action_dispatch.session = {
#   :key    => '_instatrace_session',
#   :secret => '0x0dkfj3927dkc7djdh36rkckdfzsg'
# }