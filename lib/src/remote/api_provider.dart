import 'package:flutter_app_poke/src/remote/api_base_helper.dart';
import 'package:flutter_app_poke/src/remote/models/pokemons_response.dart';

class ApiProvider{
  ApiBaseHelper helper = ApiBaseHelper();

  Future<List<Results>> fetchPokemons({int offset = 0}) async{
    final path = 'pokemon/?offset=$offset&limit=20';
    final responseString = await helper.get(path);
    final response = PokemonResponse.fromJson(responseString).results;

    return response;
  }
}