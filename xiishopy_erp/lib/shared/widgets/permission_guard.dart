/// Xiishopy ERP - Permission Guard Widget
/// Wraps widgets and restricts visibility based on user permissions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/permission_constants.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';

class PermissionGuard extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final userRole = state.user.role;
          if (_hasPermission(userRole, context)) {
            return child;
          }
          return fallback ?? const SizedBox.shrink();
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }

  bool _hasPermission(String role, BuildContext context) {
    // Super admin has all permissions
    if (role == 'super_admin') return true;

    final permissions = DefaultPermissions.getPermissionsForRole(role);
    return permissions.contains(permission);
  }
}

class RoleGuard extends StatelessWidget {
  final List<String> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          if (allowedRoles.contains(state.user.role) || state.user.role == 'super_admin') {
            return child;
          }
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}