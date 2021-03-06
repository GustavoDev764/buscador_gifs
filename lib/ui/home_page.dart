import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as htpp; 



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState(){
    super.initState();

    // _getGifs().then((map){
    //   print(map);
    // });
    
  }

  String _search;
  int _offset = 0;
  int _limit  = 19;
  
  //pegando a rota de gifs
  
  Future<Map>_getGifs() async{
    
    htpp.Response response;

    if(_search == null){

        //os melhores gifs
        response = await htpp.get("https://api.giphy.com/v1/gifs/trending?api_key=htoPUbHidd7drMMd95k4pfzJnL0LLSjl&limit=${_limit}&rating=G&lang=pt");
    }else{
       
        //buscando gifs por palavras
        response = await htpp.get("https://api.giphy.com/v1/gifs/search?api_key=htoPUbHidd7drMMd95k4pfzJnL0LLSjl&q=${_search}&limit=${_limit}&offset=${_offset}&rating=G&lang=pt");
    }  
    return jsonDecode(response.body); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                    decoration: InputDecoration(
                      labelText: "Pesquise aqui",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    textAlign: TextAlign.center,
                    onSubmitted: (text){
                      setState(() {
                        _search = text;
                        _offset = 0;
                      });
                    },
                  ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot){
                  
                  
                
                  switch(snapshot.connectionState){

                    // case ConnectionState.none:
                    //  
                    //   break;
                    // case ConnectionState.waiting:
                    //   
                    //   break;
                    // case ConnectionState.active:
                    //   
                    //   break;
                    // case ConnectionState.done:
                    //  
                    //   break; 

                    case ConnectionState.waiting:
                    case ConnectionState.none:
                          return Container(
                            width: 200.0,
                            height: 200.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5.0,
                            ),
                          );
                      break;
                    
                    case ConnectionState.done:
                        return _createGifTable(context, snapshot);
                    break;
                    
                    default:
                      
                      if (snapshot.hasError) {
                        return Container(
                          child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: TextField(
                                          decoration: InputDecoration(
                                            labelText: "Erro no app",
                                            labelStyle: TextStyle(color: Colors.white),
                                            border: OutlineInputBorder(),
                                          ),
                                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                        
                        );
                      }else{
                         return _createGifTable(context, snapshot);
                      } 
                    
                    
                  }
                  
                
                },
              ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data){
    
    if(_search == null || _search.isEmpty){
        return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
            padding: EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0
            ),
            itemCount: _getCount(snapshot.data["data"]),
            itemBuilder: (context, index){

              if(_search == null || index < snapshot.data["data"].length){
                  return GestureDetector(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                      height: 300.0,
                      fit: BoxFit.cover,
                    ),
                    onTap: (){
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (contex) => GifPage(snapshot.data["data"][index]))
                      );
                    },
                  );
              }else{
                return Container(
                  child: GestureDetector(
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.add, color: Colors.white, size: 70.0), 
                            Text("Carrega mais...",
                              style: TextStyle(color: Colors.white, fontSize: 22.0),
                            ),
                          ],
                        ),
                      onTap: (){
                        setState(() {
                          _offset += 19;
                        });
                      },
                      onDoubleTap: (){
                        Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
                      },
                  ),
                  
                );
              }
              
            },
          );
  }
}