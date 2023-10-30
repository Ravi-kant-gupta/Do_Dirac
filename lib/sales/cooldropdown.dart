import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cool_dropdown/cool_dropdown.dart';

coolDropDown(x, list) {
  CoolDropdown<String>(
    controller: x,
    dropdownList: list,
    defaultItem: null,
    onChange: (value) async {
      if (x.isError) {
        await x.resetError();
      }
      x.close();
    },
    onOpen: (value) {},
    resultOptions: ResultOptions(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 200,
      icon: const SizedBox(
        width: 10,
        height: 10,
        child: CustomPaint(
          painter: DropdownArrowPainter(),
        ),
      ),
      render: ResultRender.all,
      placeholder: 'Select Fruit',
      isMarquee: true,
    ),
    dropdownOptions: DropdownOptions(
        top: 20,
        height: 400,
        gap: DropdownGap.all(5),
        borderSide: BorderSide(width: 1, color: Colors.black),
        padding: EdgeInsets.symmetric(horizontal: 10),
        align: DropdownAlign.left,
        animationType: DropdownAnimationType.size),
    dropdownTriangleOptions: DropdownTriangleOptions(
      width: 20,
      height: 30,
      align: DropdownTriangleAlign.left,
      borderRadius: 3,
      left: 20,
    ),
    dropdownItemOptions: DropdownItemOptions(
      isMarquee: true,
      mainAxisAlignment: MainAxisAlignment.start,
      render: DropdownItemRender.all,
      height: 50,
    ),
  );
}
