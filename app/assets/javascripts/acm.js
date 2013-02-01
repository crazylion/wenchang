(function() {
    var $searchResult=$("#searchResult");
    $('#searchInput').keypress(function(event) {
       if(event.which==13) {
        $("#searchBtn").trigger("click");
       }   
    }); 

    $searchResult.on("click",".addFavorite",function() {
       var id = $(this).attr("data-id") ;
       $.post("/papers/"+id+"/add_favor",function() {
           
       });
    });

    $("#searchBtn").on("click",function() {
      var keyword =  $("#searchInput").val();
      $.post("/acm/search",{keyword:keyword},function(data) {
         $searchResult.empty()  ;
         for(var i=0,l=data.length;i<l;i++){
             var result="<div style='min-height:160px;margin-top:10px;'><table>"+
                "<tr><td colspan='2'><a href='"+data[i].link+"' target='_blank'>"+data[i].title+"</a> <a href='#' class='sendPaper' data-href='"+data[i].link+"'><i class='icon-envelope' title='mail'></i></a><a href='#' class='addFavorite' data-id='"+data[i].id+"'><i class='icon-star-empty'></i></a>  </td></tr>"+
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

//     $(".favoritePaper").each(function() {
//         $(this).popover("show");
//     });
    $(".favoritePaper").popover({selector:true}).on("mouseover",function() {
        $(this).popover('show');
    }).on("mouseout",function() {
        $(this).popover('hide');
        
    })
    
})() 
