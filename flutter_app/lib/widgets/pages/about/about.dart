import 'package:flutter/material.dart';
import '../../../assert.dart';

class About extends BasePage {
  About() : super(title: '关于');
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  var iconUrl = '';
  var name = '';
  var version = '';
  var description = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAppSpec().then((spec) {
        setState(() {
          iconUrl = spec.iconUrl;
          name = spec.name;
          version = spec.version;
          description = spec.description;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThinnerAppBar(
        title: widget.title,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        color: null,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 55),
            ),
            Container(
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image(
                      image: NetworkImage(iconUrl),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 34),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Text(
              version,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 34),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Spec> getAppSpec() async {
    var specString = await NativeInterface.getAppSpec();
    var specJson = json.decode(specString);
    var spec = Spec.fromJson(specJson);
    return spec;
  }
}
