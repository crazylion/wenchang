class AcmController < ApplicationController
  def fetch
    @email =  ""
    @email = current_user.email  if user_signed_in?
  end

  def mail
    p params[:page]
   Delayed::Job.enqueue(DelayedRake.new("download",:page=>params[:page])) 
   render :text=>"ok"
  end

  def search
    if params[:keyword].nil?
      render
    else
      result = do_search(params[:keyword])
      render :json=>result
    end
    
  end


  private

  def do_search keyword
           baseUrl="http://dl.acm.org"
        conn = Faraday.new(:url => baseUrl) do |faraday|
            faraday.request  :url_encoded             # form-encode POST params
            faraday.response :logger                  # log requests to STDOUT
            faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end 
        response =conn.post "/results.cfm",{:query=>term}
        doc =Nokogiri::HTML(response.body)
        #  doc =Nokogiri::HTML(open("test.html"))
        # find  published date
        table = doc.css("table")[10]
        i=0 
        articles=[]
        for a_table in table.xpath("//tr[3]/td/table/tr[3]/td[2]/table/tr/td[2]/table")
            title = a_table.search("tr")[0].search("td/a")[0].text.strip
            link = a_table.search("tr")[0].search("td/a")[0]["href"]
            authors =[] 

            for author in a_table.search("tr")[0].search("td[1]/div/a")
                authors.push({
                    :name=>author.text,
                    :link=>baseUrl+"/"+author["href"]
                })  
            end 
            date = a_table.search("tr")[1].search("td")[0].text.strip
            publisher  = a_table.search("tr")[2].search("td")[0].text.strip
            abstract,keyword = a_table.search("div.abstract2").text.strip.split("...")
            abstract.strip! unless abstract.nil?
            keyword = (keyword.strip)[10...-1] unless keyword.nil?

            articles.push({
                :title=>title,
                :link=>baseUrl+"/"+link,
                :authors=>authors, 
                :date=>date,
                :publisher => publisher[11..-1],
                :abstract=> abstract,
                :keyword => keyword
            })
        end
        return articles
  end
end
