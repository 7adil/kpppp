// FutureBuilder(
//     future:_totalsFuture,
//     builder: (context, snapshot){
//       return Column(
//         children: [
//           Row(
//             children: [
//               // Expanded(
//               //   child: CustomTextField(
//               //     controller: _controller1,
//               //     labelText: 'Electric Bill',
//               //     keyboardType: TextInputType.number,
//               //   ),
//               // ),
//               Expanded(
//                 child: TextField(
//                   controller: totalEarningController,
//                   decoration: const InputDecoration(
//                     labelText: 'Total Earning',
//                     border: OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: CustomTextField(
//                   controller: maintenanceController,
//                   labelText: 'Maintenance',
//                   keyboardType: TextInputType.number,
//                   readOnly: true,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: totalProfitController,
//                   decoration: const InputDecoration(
//                     labelText: 'Profit',
//                     border: OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
// }),