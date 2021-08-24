class Task < ApplicationRecord
  CATEGORY = {'bihu' => '币乎'}

  def bihu
    page_num = 0
    while page_num
      page_num += 1
      url = self.url + page_num.to_s
      response = RestClient::Request.execute(:url => url, :method => :get, :verify_ssl => false, :headers => {uuid: '316b35bcbb2d3eadcc9f4da82103599d'}).body
      if (data = JSON.parse response) && data['code'] == 1 && data['data']['data'].present?
        data['data']['data'].each do |article|
          content = article['content']
          next if content['contentUrl'].blank?
          c_url = "https://oss-cdn2.bihu-static.com/#{content['contentUrl']}"
          response = RestClient::Request.execute(:url => c_url, :method => :get, :verify_ssl => false).body.force_encoding('utf-8')
          post_info = PostInfo.find_or_initialize_by(task_category: 'bihu', uuid: content['id'])
          break unless post_info.new_record?
          post_info.assign_attributes(url: "https://bihu.com/article/" + content['id'].to_s,
                                      published_at: Time.at(content['createTs'].to_s[0..-4].to_i),
                                      author:  article['author']['nickname']
                                      )
          post_info.build_post if post_info.post.blank?
          post_info.post.assign_attributes(user_id:User.first.id,
              title: content['title'],
              body: response,
              summary: content['brief'],
              banner: 'https://oss-cdn2.bihu-static.com/' + content['imageUrlList'][0].to_s,
              slug: content['title'],
              created_at: Time.at(content['createTs'].to_s[0..-4].to_i))
          post_info.save
          post_info.post.save

          sleep(10)
        end
      else
        break
      end
    end

  end

  def wordy s
    s.split(/\<.*?\>/)
        .map(&:strip)
        .reject(&:empty?)
        .join(' ')
        .gsub(/\s,/, ',')
  end

  def get_content
    wordy(response)
    # self.update(content: wordy(response))
  end

end
