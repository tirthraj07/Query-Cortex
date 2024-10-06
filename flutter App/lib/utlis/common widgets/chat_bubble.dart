import 'package:flutter/material.dart';

import '../../colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String timestamp;
  final bool isImage;
  final bool isInsight;
  final List?
      insights; // Add this flag to indicate whether the message is an image

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.timestamp,
      this.isImage = false,
      this.isInsight = false,
      this.insights});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width /
            1.5, // Set your desired maximum width
      ),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: isCurrentUser ? appBarColor : Colors.white,
        borderRadius: isCurrentUser
            ? const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isImage)
            GestureDetector(
              onTap: () {
                // Show the dialog with the larger image when tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        width: double.infinity, // Make dialog full width
                        // Set a height for the dialog
                        child: InteractiveViewer(
                          boundaryMargin:
                              EdgeInsets.all(20), // Margin around the boundary
                          minScale: 0.5, // Minimum zoom-out scale
                          maxScale: 4.0, // Maximum zoom-in scale
                          child: Image.network(
                            message,
                            fit: BoxFit
                                .contain, // Adjust to fit the image within the dialog
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(message),
                    fit:
                        BoxFit.cover, // Ensure it covers the container properly
                  ),
                ),
                child: Image.network(message,
                    fit: BoxFit.cover), // Display thumbnail image
              ),
            )
          else if (isInsight)
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Insights",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  for (int i = 0; i < insights!.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0), // Spacing between bullet points
                      child: Text(
                        "${i + 1}.  ${insights![i]}", // Numbered bullet
                        style: TextStyle(fontSize: 14), // Customize text size
                      ),
                    ),
                ],
              ),
            )
          else // Otherwise render text
            Text(
              message,
              style: TextStyle(
                  fontSize: 16,
                  color: isCurrentUser ? Colors.white : Colors.black),
            ),
          const SizedBox(height: 5), // Space between the message and timestamp
          Text(
            timestamp,
            style: TextStyle(
                fontSize: 10,
                color: isCurrentUser ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
