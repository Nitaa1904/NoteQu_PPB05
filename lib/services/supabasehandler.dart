import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class SupabaseHandler {
  static String supaBaseURL =
      "https://ghvhnzmuhazipuiehckv.supabase.co"; // Masukkan URL Supabase Anda
  static String supaBaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdodmhuem11aGF6aXB1aWVoY2t2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU3MTExNjgsImV4cCI6MjA1MTI4NzE2OH0.1MNF_GxLE4hufUc5CO2sssvgE3nXJ5TpsY89iEiBx5o"; // Masukkan Anon Key Supabase Anda

  final client = SupabaseClient(supaBaseURL, supaBaseKey);

  /// Menambahkan data ke tabel "todotable"
  Future<void> addData(String taskValue, bool statusValue) async {
    try {
      final response = await client.from("todotable").insert({
        'tasks': taskValue,
        'status': statusValue,
      });

      if (response.hasError) {
        // Tangani error jika ada
        print("Error saat menambahkan data: ${response.error?.message}");
      } else {
        print("Data berhasil ditambahkan: ${response.data}");
      }
    } catch (e) {
      print("Kesalahan saat menambahkan data: $e");
    }
  }

  /// Membaca data dari tabel "todotable"
  Future<List<dynamic>> readData() async {
    try {
      final response = await client
          .from("todotable")
          .select()
          .order('tasks', ascending: true);

      if (response.hasError) {
        // Tangani error jika ada
        print("Error saat membaca data: ${response.error?.message}");
        return [];
      } else {
        print("Data berhasil dibaca: ${response.data}");
        return response.data as List<dynamic>;
      }
    } catch (e) {
      print("Kesalahan saat membaca data: $e");
      return [];
    }
  }

  /// Memperbarui status data di tabel "todotable"
  Future<void> updateData(int id, bool statusValue) async {
    try {
      final response = await client
          .from("todotable")
          .update({'status': statusValue}).eq('id', id);

      if (response.hasError) {
        // Tangani error jika ada
        print("Error saat memperbarui data: ${response.error?.message}");
      } else {
        print("Data berhasil diperbarui: ${response.data}");
      }
    } catch (e) {
      print("Kesalahan saat memperbarui data: $e");
    }
  }

  /// Menghapus data dari tabel "todotable"
  Future<void> deleteData(int id) async {
    try {
      final response = await client.from("todotable").delete().eq('id', id);

      if (response.hasError) {
        // Tangani error jika ada
        print("Error saat menghapus data: ${response.error?.message}");
      } else {
        print("Data berhasil dihapus: ${response.data}");
      }
    } catch (e) {
      print("Kesalahan saat menghapus data: $e");
    }
  }
}
