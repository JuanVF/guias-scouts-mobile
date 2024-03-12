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
import 'package:guias_scouts_mobile/common/token_manager.dart';
import 'package:guias_scouts_mobile/services/auth_service.dart';

enum LoginResponse {
  NEEDS_CONFIRMATION,
  SUCCESS,
  INVALID_CREDENTIALS,
  SERVER_ERROR
}

enum ConfirmCodeResponse {
  SUCCESS,
  INVALID_CODE,
  SERVER_ERROR
}

class AuthController {
  final AuthService service = AuthService();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await service.login(email, password);

      if (response.containsKey('error')) {
        return LoginResponse.SERVER_ERROR;
      }

      if (response['status'] == 401) {
        return LoginResponse.INVALID_CREDENTIALS;
      }

      if (response['body'].containsKey('redirect')) {
        return LoginResponse.NEEDS_CONFIRMATION;
      }

      TokenManager.storeToken(response['body']['token']);

      return LoginResponse.SUCCESS;
    } catch (e) {
      // Exception occurred during request
      return LoginResponse.SERVER_ERROR;
    }
  }

  Future<ConfirmCodeResponse> confirmUser(String email, String code) async {
    try {
      final response = await service.confirmUser(email, code);

      if (response.containsKey('error')) {
        return ConfirmCodeResponse.SERVER_ERROR;
      }

      if (response['status'] == 401) {
        return ConfirmCodeResponse.INVALID_CODE;
      }

      TokenManager.storeToken(response['body']['token']);

      return ConfirmCodeResponse.SUCCESS;
    } catch (e) {
      // Exception occurred during request
      return ConfirmCodeResponse.SERVER_ERROR;
    }
  }
}
