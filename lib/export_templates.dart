import 'dart:convert';
import 'package:flutter/material.dart';
import 'data/template_data.dart';

void main() {
  // Convert categories to JSON
  final jsonData = {
    'categories':
        TemplateData.categories.map((category) {
          return {
            'name': category.name,
            'templates':
                category.templates.map((template) {
                  return template.toJson();
                }).toList(),
          };
        }).toList(),
  };

  // Pretty print JSON
  final prettyJson = JsonEncoder.withIndent('  ').convert(jsonData);
  print(prettyJson);
}
