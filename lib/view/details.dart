
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/controller/details.dart';


class DetailsPage extends StatefulWidget {
  final int productId;// The ID of the product to display details for

  DetailsPage({required this.productId});// Constructor requires a productId

  @override
  _DetailsPageState createState() => _DetailsPageState();
  // Creates the state for DetailsPage
}


class _DetailsPageState extends State<DetailsPage> {
  DetailsController _controller = DetailsController();
// Instantiate the DetailsController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _controller.navigateBack(context);// Handle navigation back when pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(  // Builds a widget based on the latest snapshot of asynchronous computation
          future: _controller.fetchProductDetails(widget.productId),
          // Fetch product details using the productId
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return StatefulBuilder( // Allows for local state management within the widget
                builder: (BuildContext context, StateSetter setState) {
                  // Calls buildDetailsView from DetailsController to display the product details
                  return _controller.buildDetailsView(context, snapshot, setState);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

