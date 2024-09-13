import 'package:flutter/material.dart';
import 'package:get/get.dart';


void showGenericListDialog<T>({
  required List<T> itemList,
  required T? selectedItem,
  required String Function(T) getItemName,
  required void Function(T) onItemSelected,
  required String dialogTitle,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: Get.width,
        height: 500,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    dialogTitle.tr ?? "",
                    style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: itemList.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              onItemSelected(itemList[i]);
                              Get.back();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.grey))),
                              child: Text(
                                getItemName(itemList[i]),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selectedItem == itemList[i]
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(onPressed: (){
                  Get.back();
                }, child: Text("Submit"))
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/*void showGenericListDialog<T>({
  required List<T> itemList,
  required T? selectedItem,
  required String Function(T) getItemName,
  required void Function(T) onItemSelected,
}) {
  Get.dialog(
    AlertDialog(
      title: Text('select_item'.tr), // You can pass a different title if needed
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            final item = itemList[index];
            return ListTile(
              title: Text(getItemName(item)),
              selected: item == selectedItem,
              onTap: () {
                onItemSelected(item);
                Get.back(); // Close the dialog
              },
            );
          },
        ),
      ),
    ),
  );
}*/
