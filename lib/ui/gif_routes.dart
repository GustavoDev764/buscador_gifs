import 'package:flutter/material.dart';

class GifRoutes{

    String _key = "htoPUbHidd7drMMd95k4pfzJnL0LLSjl";
    

    //parametros opicional
    getTrending<String>({limit: 20}){
      return "https://api.giphy.com/v1/gifs/trending?api_key="+_key+"&limit="+limit+"&rating=G"; 
      
    }

    getSearch<String>(dynamic keySearch, dynamic offset,{limit: 20}){
      return "https://api.giphy.com/v1/gifs/search?api_key="+_key+"&q="+keySearch+"&limit="+limit+"&offset="+offset+"&rating=G&lang=pt";
       
    }

    getLogo<String>(){
      return "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif";
    }


    


}