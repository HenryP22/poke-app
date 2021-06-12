import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_poke/src/bloc/Pokemons/pokemons_bloc.dart';
import 'package:flutter_app_poke/src/bloc/Pokemons/pokemons_event.dart';
import 'package:flutter_app_poke/src/bloc/Pokemons/pokemons_state.dart';
import 'package:flutter_app_poke/src/remote/models/pokemons_response.dart';

final Set<Results> saved = Set<Results>();

class HomePage extends StatelessWidget {
  PokemonsBloc pokeBloc;
  bool scrollSwitch = true;

  @override
  Widget build(BuildContext context) {
    pokeBloc = BlocProvider.of<PokemonsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemons List App - Lunes 2Nov'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.chrome_reader_mode),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => pushSaved(context)
                  ));
              },)
        ],
      ),
      body: _body(context),

    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<PokemonsBloc, PokemonsState>(
      bloc: pokeBloc,
      builder: (context, state) {
        if (state is WithoutPokemonsState) {
          pokeBloc.add(AddMorePokemons());
          print("entro a witout");
          return Center(child: CircularProgressIndicator());
        }

        if (state is WithPokemonsState) {
          print("entro a witt");
          scrollSwitch = true;
          return _list(state);
        }
      },
    );
  }

  Widget _list(WithPokemonsState state) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          scrollSwitch == true) {
        scrollSwitch = false;
        pokeBloc.add(AddMorePokemons());
      }
    });

    return ListView.builder(
      controller: scrollController,
      itemCount: state.pokemons.length,
      itemBuilder: (BuildContext context, int index) {
        return _listTile(state.pokemons, index, context);
      },
    );
  }

  Widget _listTile(List<Results> pokemons, int index, BuildContext context) {

    final bool alreadySaved = saved.contains(pokemons[index]);

    final chunks = pokemons[index].url.split('/');
    var id = chunks[6];
    print(chunks);
    print("numero de pokemon: "+id);
    pokemons[index].id = id;
    return ListTile(
      leading: Text(id),
      title: Text(pokemons[index].name),
      trailing: Image(
        image: NetworkImage(
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${id}.png'),
      ),
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Details(id, pokemons[index], alreadySaved)
            ));
      },
    );
  }

  Widget pushSaved(BuildContext context) {

              final Iterable<ListTile> tiles = saved.map(
                    (Results pair){
                  return ListTile(
                    title: Text(pair.name
                    ),
                    trailing: Image(
                      image: NetworkImage(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pair.id}.png'),
                    ),
                  );
                }
              );
              final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              )
                  .toList();
              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved suggestions!!!'),
                ),
                body: ListView(
                  children: divided,
                ),
              );



  }
}


class Details extends StatelessWidget {
  final id;
  final pokemon;
  final alreadySaved;

  Details(this.id, this.pokemon, this.alreadySaved);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Image'),
        backgroundColor: Colors.black87,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(alreadySaved){
            saved.remove(pokemon);
          }else{
            saved.add(pokemon);
          }
        },
        child: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 300.0,
                height: 250.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://assets.pokemon.com/assets/cms2/img/pokedex/detail/00${id}.png'
                    ),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),
            Divider(
              height: 60.0,
              color: Colors.red,
            ),
            Text(
              pokemon.name,
              style: TextStyle(
                color: Colors.blue,
                letterSpacing: 2.0,
                fontSize: 28.0
              ),
            )
          ],
        ),
      ),
    );
  }

}