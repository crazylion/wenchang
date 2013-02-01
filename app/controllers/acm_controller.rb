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
        response =conn.post "/results.cfm",{:query=>keyword}
        doc =Nokogiri::HTML(response.body)
        #  doc =Nokogiri::HTML(open("test.html"))
        # find  published date
        table = doc.css("table")[10]
        i=0 
        articles=[]
        for a_table in table.xpath("//tr[3]/td/table/tr[3]/td[2]/table/tr/td[2]/table")
            title = a_table.search("tr")[0].search("td/a")[0].text.strip
            link = a_table.search("tr")[0].search("td/a")[0]["href"]
            match = link.match(/id=(\d+)/)
            acm_id=nil
            acm_id = match[1] unless match[1].nil?
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
            #加到資料庫裡面
            
            paper = Paper.find_by_acm_id(acm_id)
            id=nil
            if paper.nil?
              id=Paper.new(:title=>title,
                        :source=>"acm",
                        :abstract=>abstract,
                        :acm_id=>acm_id,
                        :published_at=>:date,
                        :link=>link
                       ).save
            else
              id=paper.id
            end

            articles.push({
                :id=>id,
                :title=>title,
                :link=>baseUrl+"/"+link,
                :authors=>authors, 
                :date=>date,
                :publisher => publisher[11..-1],
                :abstract=> abstract,
                :keyword => keyword,
                :acm_id=>acm_id
            })
        end
        return articles
  end
end
