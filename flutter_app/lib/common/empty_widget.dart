import 'package:flutter/material.dart';
import './loading_widget.dart';

class EmptyWidget extends StatefulWidget {
  EmptyWidget({
    Key key, 
    this.message, 
    this.icon, 
    this.onRefresh
    }) : super(key: key);

  final IconData icon;
  final String message;
  final RefreshCallback onRefresh;

  EmptyWidgetState createState() => EmptyWidgetState();
}

class EmptyWidgetState extends State<EmptyWidget> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: isLoading ? 0 : 1,
      children: <Widget>[
        _buildLoadingWidget(context),
        _buildEmptyWidget(context),
      ],
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return LoadingWidget();
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return InkWell(
      onTap: onRefresh,
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color: Colors.lightBlue,
                size: 80,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text(
                widget.message,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loading() {
    onRefresh();
  }
  void onRefresh() {
    setState(() {
      isLoading = true;
    });
    widget.onRefresh().then((_){
      setState(() {
        isLoading = false;
      });
    });
  }
}
