import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/app/sign_in/sign_in_bloc.dart';
import 'package:brahminapp/app/sign_in/social_sign_in_button.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInPage(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  /*Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }*/

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

/* void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
      backgroundColor: Colors.white,
    );
  }

/*  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(children: [
        Image.asset('images/back.png'),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child: _buildHeader(isLoading),
            ),
            SizedBox(height: 48.0),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: 'Sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(height: 8.0),
            */
/*SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),*/ /*
          ],
        ),
      ],),
    );
  }*/
  Widget _buildContent(BuildContext context, bool isLoading) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
            height: height,
            width: width,
            child: FlareActor("assets/flare/Background.flr", alignment:Alignment.center, fit:BoxFit.fill, animation:"Blue")),
        /*Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 150,width: 150,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.asset("images/chakra.png",color: Colors.deepOrange,),
          ),
        ),*/
        Padding(
          padding: EdgeInsets.only(left: width*0.05),
          child: Container(
            padding: EdgeInsets.all(20),
            height: height*0.3,
            width: width*0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(child: Image.asset('images/dlogo.png')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: width*0.05,top: height*0.3),
          child: Column(
            children: [
              Text("नमस्ते पुरोहित जी !",style: GoogleFonts.anton(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600)),
              Text("Proceed Login",style: GoogleFonts.anton(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w800))
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _buildHeader(isLoading),
          ),),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: 'Sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
          ),
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("hint").doc('app1').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                    height: 50, width: 50,
                    child: Center(child: CircularProgressIndicator()));
              }
              else {
                final servicess = snapshot.data;
                void hindilauncher()async{
                  var url = '${servicess.data()['purohit']}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:190.0,left: 20,right: 20),
                    child: SocialSignInButton(
                      assetName: 'images/6705.jpg',
                      text: 'ऐप चलाना सीखे ',
                      textColor: Colors.black87,
                      color: Colors.white,
                      onPressed: isLoading ? null : () => hindilauncher(),
                    ),
                  ),
                );
              }
            }
        ),
     // Align(
     //      alignment: Alignment.bottomCenter,
     //      child: SignInButton(
     //        text: 'Sign in with email',
     //        textColor: Colors.white,
     //        color: Colors.teal[700],
     //        onPressed: isLoading ? null : () => _signInWithEmail(context),
     //      ),
     //    )
        Padding(
          padding: EdgeInsets.only(bottom: height*0.02),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.end,

            children: [
              Center(child: Text('from',style: TextStyle(color: Colors.white),)),
              Center(child: Text('Puja Purohit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
      ],

    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return CircularProgressIndicator();

    }
    return Text(
      '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
