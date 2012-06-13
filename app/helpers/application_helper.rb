module ApplicationHelper
	def locale_urls
		urls = []
		%w(ru en).map do |locale|
			options = {}
			options[:class] = 'active' if current_locale == locale
			urls << link_to(locale, language_path(locale), options)
		end
		raw(urls.join(' | '))
	end
end
