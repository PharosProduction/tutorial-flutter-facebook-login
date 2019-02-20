import 'package:flutter/material.dart';
import 'package:login_app/blocs/login_provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login screen'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _buildFbLoginBt(bloc),
            _buildSignOutBt(bloc),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            _buildUserNameTitle(),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            _buildUserName(bloc),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            _buildTokenTitle(),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            _buildTokenField(bloc)
          ],
        ),
      ),
    );
  }

  Widget _buildFbLoginBt(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.facebookToken,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return RaisedButton(
          child: Text('Login with Facebook'),
          color: Color(Colors.blueAccent.blue),
          textColor: Colors.white,
          onPressed: !snapshot.hasData
              ? () async {
                  bloc.sigInFacebook();
                }
              : null,
        );
      },
    );
  }

  Widget _buildSignOutBt(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.facebookToken,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Text('Logout Facebook'),
            color: Color(Colors.blue.blue),
            textColor: Colors.white,
            onPressed: snapshot.hasData
                ? () async {
                    bloc.signOutFacebook();
                  }
                : null);
      },
    );
  }

  Widget _buildUserNameTitle() {
    return Text('User name');
  }

  Widget _buildTokenTitle() {
    return Text('Facebook Token');
  }

  Widget _buildTokenField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.facebookToken,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Text(
          snapshot.hasData ? snapshot.data : '',
          maxLines: 2,
        );
      },
    );
  }

  Widget _buildUserName(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.userName,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Text(snapshot.hasData ? snapshot.data : '');
      },
    );
  }
}
