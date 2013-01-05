(function() {
    var $searchResult=$("#searchResult");
    $('#searchInput').keypress(function(event) {
       if(event.which==13) {
        $("#searchBtn").trigger("click");
       }   
    }); 
    $("#searchBtn").on("click",function() {
      var keyword =  $("#searchInput").val();
      $.post("/acm/search",{keyword:keyword},function(data) {
         $searchResult.empty()  ;
         for(var i=0,l=data.length;i<l;i++){
             var result="<div style='min-height:160px;margin-top:10px;'><table>"+
                "<tr><td colspan='2'><a href='"+data[i].link+"' target='_blank'>"+data[i].title+"</a> <a href='#' class='sendPaper' data-href='"+data[i].link+"'><i class='icon-envelope' title='mail'></i></a>  </td></tr>"+
                "<tr><td>Published:</td><td><i='icon-calendar'/></i>"+data[i].date+", "+data[i].publisher+" </td></tr>"+                "<tr><td>Abstract:</td><td>"+data[i].abstract+"</td></tr>"+
                "<tr><td>Keywords:</td><td>"+data[i].keyword+"</td></tr>"+
                "<tr><td>Authors: </td><td>";
                for(var index in data[i].authors){
                    var author = data[i].authors[index];
                    result+= ("<a href='"+author.link+"' >"+author.name+"</a>, ");
                }   
                result+="</td></tr>"
                "</table><div>";
            $searchResult.append(result);
         }   
      }); 
    }); 
    $searchResult.on("click",".sendPaper",function() {
        var link = $(this).attr("data-href");
        $("#page").val(link);
        $("form").submit();
    
    }); 
    
})() 
