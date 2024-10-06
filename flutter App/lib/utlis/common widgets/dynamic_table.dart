import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:query_cortex/colors.dart';
import 'package:query_cortex/utlis/common%20widgets/custom_button.dart';

class DynamicTable extends StatelessWidget {
  final List data;

  const DynamicTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Return an empty container if no data is provided
    if (data.isEmpty) return Container();

    List<String> keys = data.first.keys.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set the white background color
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0, // Shadow for the container
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300), // Border around the table
            borderRadius: BorderRadius.circular(8.0),
          ),
          columns: keys.map((key) {
            return DataColumn(
              label: Text(
                key, // Display the key as the column header
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Bold text for headers
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          rows: data.map((row) {
            return DataRow(
              onSelectChanged: (selected) {
                if (selected == true) {
                  // Open a dialog with the entire table and download PDF option
                  _showTableDialog(context, keys);
                }
              },
              cells: keys.map((key) {
                return DataCell(
                  Text(
                    row[key].toString(), // Display the value for each key in the row
                    style: TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Show table dialog with the entire table
  void _showTableDialog(BuildContext context, List<String> keys) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogboxColor,
          title: Center(child: Text("Detailed Table View", style: TextStyle(fontWeight: FontWeight.bold),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InteractiveViewer(
                boundaryMargin: EdgeInsets.all(10.0),
                minScale: 0.5,
                maxScale: 3.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),

                    child: DataTable(

                      columns: keys.map((key) {
                        return DataColumn(
                          label: Text(
                            key, // Column header
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      rows: data.map((row) {
                        return DataRow(
                          cells: keys.map((key) {
                            return DataCell(
                              Text(row[key].toString()), // Row value
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                onTap: () => generatePDF(data, keys), // Call generatePDF with all rows
                text: 'Download as PDF',
              ),
            ],
          ),
        );
      },
    );
  }

  // Generate PDF for all rows
  Future<void> generatePDF(List data, List<String> headers) async {
    final pdf = pw.Document();

    // Add a page with the table
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Generated SQL Table', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildTable(headers, data), // Build the table widget
            ],
          );
        },
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/sql_table.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the generated PDF
    OpenFile.open(file.path);
  }

  // Method to build table for PDF with all data
  pw.Widget _buildTable(List<String> headers, List data) {
    // Convert the data into rows for the PDF table
    final List<List<String>> rows = data.map((row) {
      return headers.map((header) => row[header].toString()).toList();
    }).toList();

    // Create the table with headers and data
    return pw.Table.fromTextArray(
      headers: headers,
      data: rows,
      border: pw.TableBorder.all(width: 1), // Add borders to the table cells
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
      cellStyle: pw.TextStyle(fontSize: 12),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
    );
  }
}
