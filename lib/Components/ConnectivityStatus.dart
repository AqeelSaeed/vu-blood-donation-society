// import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
//
// class ConnectivityStatus extends StatelessWidget {
//   final Widget widget;
//
//   ConnectivityStatus(this.widget);
//
//   @override
//   Widget build(BuildContext context) {
//     double statusBarHeight = MediaQuery.of(context).padding.top;
//     return StreamBuilder<ConnectivityResult>(
//       stream: _connectivityStream,
//       builder: (context, snapshot) {
//         final bool connected = snapshot.data != ConnectivityResult.none;
//         return Stack(
//           children: <Widget>[
//             Positioned(
//               top: statusBarHeight,
//               left: 0.0,
//               right: 0.0,
//               child: Container(
//                 height: connected ? 0 : 25,
//                 color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
//                 child: Center(
//                   child: connected
//                       ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "ONLINE",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   )
//                       : Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "OFFLINE",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       SizedBox(
//                         width: 8.0,
//                       ),
//                       SizedBox(
//                         width: 12.0,
//                         height: 12.0,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.0,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             widget,
//           ],
//         );
//       },
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   double statusBarHeight = MediaQuery.of(context).padding.top;
//   //   return OfflineBuilder(
//   //     connectivityBuilder: (
//   //       BuildContext context,
//   //       ConnectivityResult connectivity,
//   //       Widget child,
//   //     ) {
//   //       final bool connected = connectivity != ConnectivityResult.none;
//   //       return Stack(
//   //         children: <Widget>[
//   //           Positioned(
//   //             top: statusBarHeight,
//   //             left: 0.0,
//   //             right: 0.0,
//   //             child: Container(
//   //               height: connected ? 0 : 25,
//   //               color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
//   //               child: Center(
//   //                 child: connected
//   //                     ? Row(
//   //                         mainAxisAlignment: MainAxisAlignment.center,
//   //                         children: <Widget>[
//   //                           Text(
//   //                             "ONLINE",
//   //                             style: TextStyle(color: Colors.white),
//   //                           ),
//   //                         ],
//   //                       )
//   //                     : Row(
//   //                         mainAxisAlignment: MainAxisAlignment.center,
//   //                         children: <Widget>[
//   //                           Text(
//   //                             "OFFLINE",
//   //                             style: TextStyle(color: Colors.white),
//   //                           ),
//   //                           SizedBox(
//   //                             width: 8.0,
//   //                           ),
//   //                           SizedBox(
//   //                             width: 12.0,
//   //                             height: 12.0,
//   //                             child: CircularProgressIndicator(
//   //                               strokeWidth: 2.0,
//   //                               valueColor: AlwaysStoppedAnimation<Color>(
//   //                                 Colors.white,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //               ),
//   //             ),
//   //           ),
//   //           widget,
//   //         ],
//   //       );
//   //     },
//   //     child: widget,
//   //   );
//   // }
// }
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityStatus extends StatefulWidget {
  final Widget child;

  const ConnectivityStatus({required this.child, Key? key}) : super(key: key);

  @override
  _ConnectivityStatusState createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus> {
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged.expand((list) => list);
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream,
      builder: (context, snapshot) {
        final bool connected = snapshot.data != ConnectivityResult.none;
        return Stack(
          children: <Widget>[
            Positioned(
              top: statusBarHeight,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: connected ? 0 : 25,
                color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                child: Center(
                  child: connected
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "ONLINE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "OFFLINE",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      SizedBox(
                        width: 12.0,
                        height: 12.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}
