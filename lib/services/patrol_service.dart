// Copyright (c) 2024 Guias Scouts
//
// All rights reserved. This file and the source code it contains is
// confidential and proprietary to Guias Scouts. No part of this
// file may be reproduced, stored in a retrieval system, or transmitted
// in any form or by any means, electronic, mechanical, photocopying,
// recording, or otherwise, without the prior written permission of
// Guias Scouts.
//
// This file is provided "as is" with no warranties of any kind, express
// or implied, including but not limited to, any implied warranty of
// merchantability, fitness for a particular purpose, or non-infringement.
// In no event shall Guias Scouts be liable for any direct, indirect,
// incidental, special, exemplary, or consequential damages (including, but
// not limited to, procurement of substitute goods or services; loss of use,
// data, or profits; or business interruption) however caused and on any
// theory of liability, whether in contract, strict liability, or tort
// (including negligence or otherwise) arising in any way out of the use
// of this software, even if advised of the possibility of such damage.
//
// For licensing opportunities, please contact tropa92cr@gmail.com.
import 'dart:convert';
import 'package:guias_scouts_mobile/common/token_manager.dart';
import 'package:guias_scouts_mobile/services/service_config.dart';
import 'package:http/http.dart' as http;

class PatrolService {
  final String baseUrl = '${ServiceConfig.host}/patrol';

  /// Create Patrol
  Future<Map<String, dynamic>> add(Map<String, dynamic> patrol) async {
    final url = Uri.parse('$baseUrl/add-patrol');

    try {
      final token = await TokenManager.getToken();
      final response = await http.post(
        url,
        body: json.encode(patrol),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return responseData;
      } else {
        // Request failed
        return {'error': 'Failed to create patrol. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      // Exception occurred during request
      return {'error': 'Exception occurred: $e'};
    }
  }

  /// delete patrol
  Future<Map<String, dynamic>> delete(String name) async {
    final url = Uri.parse('$baseUrl/delete-patrol?name=$name');

    try {
      final token = await TokenManager.getToken();
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return responseData;
      } else {
        // Request failed
        return {'error': 'Failed to delete patrol. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      // Exception occurred during request
      return {'error': 'Exception occurred: $e'};
    }
  }

  /// delete patrol
  Future<Map<String, dynamic>> getAll() async {
    final url = Uri.parse('$baseUrl/get-all');

    try {
      final token = await TokenManager.getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        return responseData;
      } else {
        // Request failed
        return {'error': 'Failed to delete patrol. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      // Exception occurred during request
      return {'error': 'Exception occurred: $e'};
    }
  }
}
