module ApplicationHelper
	def locale_urls
		urls = []
		%w(es en).map do |locale|
			options = {}
			options[:class] = 'active' if current_locale == locale
			urls << link_to(locale, language_path(locale), options)
		end
		raw(urls.join(' | '))
	end

	def damages_urls(milestone)
		urls = []
		milestone.damages.each_with_index do |damage,i| 
        	urls << link_to("#{i+1}", damage.photo.url, :target => "_blank")
        end if milestone.damages
        raw(urls.join(', '))
	end

	def documents_urls(milestone)
		urls = []
		milestone.milestone_documents.each_with_index do |document,i| 
        	urls << link_to("#{i+1}", document.name.url, :target => "_blank")
        end if milestone.milestone_documents
        raw(urls.join(', '))
	end
end
