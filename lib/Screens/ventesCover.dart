// import 'package:flutter/material.dart';
// import 'package:moussa_project/Models/materiels.dart';

// class VenteCover extends StatefulWidget {
//   VenteCover({super.key, required this.materiel});
//   Materiel materiel;
//   @override
//   State<VenteCover> createState() => _VenteCoverState();
// }

// class _VenteCoverState extends State<VenteCover> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.materiel.title),),
//       body: Padding(
//         padding: const EdgeInsets.only(left:20.0, right: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 child: ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.circular(8)),
//                 child: Image.network(
//                   widget.materiel.image,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//                 ),
//             ),
//             Text(widget.materiel.title, style: TextStyle(fontSize: 30),),
//             Text(widget.materiel.description??""),
//             Spacer(),
//             Text("Prix:"),
//             Text("${widget.materiel.price} XOF",style: TextStyle(fontSize: 20)),
//             TextButton.icon(
//               onPressed: (){}, label: Text("Acheter maintenant"), 
//               icon: Image.asset("assets/images/achat.png", scale: 50,),)
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/Models/materiels.dart';
import 'package:url_launcher/url_launcher.dart';

class VenteCover extends StatefulWidget {
  final Materiel materiel;

  const VenteCover({Key? key, required this.materiel}) : super(key: key);

  @override
  _VenteCoverState createState() => _VenteCoverState();
}

class _VenteCoverState extends State<VenteCover> {
  @override
  Widget build(BuildContext context) {


  void launchWhatsApp(BuildContext context, String phone, String message) async {
    //final whatsappUrl = "https://wa.me/$phone";
    final whatsappUrl= "https://wa.me/$phone/?text=${Uri.encodeQueryComponent(message)}";
    print(whatsappUrl);
    print(await canLaunchUrl(Uri.parse(whatsappUrl)));
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      //await launchUrl(Uri(scheme: "whatsapp",path: phone,query: message));
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on this device."),
        ),
      );
    }
  }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.materiel.title, style: const TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.materiel.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.materiel.title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.materiel.description ?? "",
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
              "PRIX :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(5),
            Text(
              "${widget.materiel.price} XOF",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextButton.icon(
              onPressed: () {
                launchWhatsApp(context, widget.materiel.telephone, "Comment avoir ce produit Nom: ${widget.materiel.title}, description: ${widget.materiel.description} et prix:${widget.materiel.price}?");
              },
              label: const Text("Acheter maintenant"),
              icon: Image.asset(
                "assets/images/achat.png",
                scale: 20,
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
