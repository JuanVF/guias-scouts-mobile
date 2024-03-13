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
import 'package:guias_scouts_mobile/services/user_service.dart';

enum ChangePasswordResponse {
  SUCCESS,
  INVALID_PASSWORD,
  SERVER_ERROR
}

enum CreateUserResponse {
  SUCCESS,
  SERVER_ERROR
}

class UserController {
  final UserService service = UserService();

  Future<ChangePasswordResponse> changePassword(String email, String password) async {
    try {
      final response = await service.login(email, password);

      if (response.containsKey('error')) {
        return ChangePasswordResponse.SERVER_ERROR;
      }

      if (response['status'] != 200) {
        return ChangePasswordResponse.INVALID_PASSWORD;
      }

      return ChangePasswordResponse.SUCCESS;
    } catch (e) {
      // Exception occurred during request
      return ChangePasswordResponse.SERVER_ERROR;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await service.getProfile();

      if (response.containsKey('error')) {
        return {};
      }

      if (response['status'] != 200) {
        return {};
      }

      return response['body']['user'];
    } catch (e) {
      // Exception occurred during request
      return {};
    }
  }

  Future<CreateUserResponse> createUser(Map<String, dynamic> user) async {
    try {
      final response = await service.createUser(user);

      if (response.containsKey('error')) {
        return CreateUserResponse.SERVER_ERROR;
      }

      if (response['status'] != 200) {
        return CreateUserResponse.SERVER_ERROR;
      }

      return CreateUserResponse.SUCCESS;
    } catch (e) {
      // Exception occurred during request
      return CreateUserResponse.SERVER_ERROR;
    }
  }
}
