import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_poke/simple_bloc_delegate.dart';
import 'package:flutter_app_poke/app.dart';
import 'package:flutter_app_poke/src/bloc/Pokemons/pokemons_bloc.dart';
import 'package:flutter_app_poke/src/repository/pokemon_repository.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  PokemonRepository pokemonRepository = PokemonRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<PokemonsBloc>(
        create: (BuildContext context) =>
            PokemonsBloc(pokemonRepository: pokemonRepository),
      )
    ],
    child: MyApp(),
  ));
}

