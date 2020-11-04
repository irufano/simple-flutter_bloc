import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_flutter/blocs/album/bloc.dart';
import 'package:training_flutter/blocs/album/events.dart';
import 'package:training_flutter/blocs/album/states.dart';
import 'package:training_flutter/models/album.dart';
import 'package:training_flutter/screens/reset_screen.dart';

class AlbumScreen extends StatefulWidget {
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  _loadAlbums() async {
    context.bloc<AlbumsBloc>().add(AlbumEvents.fetchAlbums);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    return Column(
      children: [
        RaisedButton(onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ResetScreen()));
        }),
        BlocBuilder<AlbumsBloc, AlbumsState>(
            builder: (BuildContext context, AlbumsState state) {
          if (state is AlbumsListError) {
            final error = state.error;
            String message = '${error.message}\nTap to Retry.';
            return Expanded(
              child: Center(
                child: Text(message),
              ),
            );
          }
          if (state is AlbumsLoaded) {
            List<Album> albums = state.albums;
            return _list(albums);
          }
          return Center(child: CircularProgressIndicator());
        }),
      ],
    );
  }

  Widget _list(List<Album> albums) {
    return Expanded(
      child: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (_, index) {
          Album album = albums[index];

          return ListTile(
            title: Text(
              album.title,
            ),
            subtitle: Text(
              album.userId.toString(),
            ),
          );
        },
      ),
    );
  }
}
