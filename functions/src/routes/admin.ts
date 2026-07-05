/**
 * Xiishopy ERP - Admin Route Module
 * Provides admin dashboard, system config, user management, audit logs, and analytics endpoints.
 */

import { Router, Request, Response } from 'express';
import { Firestore } from 'firebase-admin/firestore';
import { getFirestore } from 'firebase-admin/firestore';
import { HTTP_STATUS } from '../config/constants';

const ADMIN_ROLES = ['super_admin', 'admin'];

const router = Router();
const db: Firestore = getFirestore();

// ── Admin Guard Middleware ──
const adminGuard = async (req: Request, res: Response, next: Function) => {
  try {
    const userId = (req as any).user?.uid;
    if (!userId) {
      return res.status(HTTP_STATUS.UNAUTHORIZED).json({ success: false, message: 'Unauthorized' });
    }
    const userDoc = await db.collection('users').doc(userId).get();
    const userData = userDoc.data();
    const role = userData?.role || '';
    if (!ADMIN_ROLES.includes(role)) {
      return res.status(HTTP_STATUS.FORBIDDEN).json({ success: false, message: 'Admin access required' });
    }
    next();
  } catch (error) {
    return res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Authorization error' });
  }
};

// Apply admin guard to all routes in this module
router.use(adminGuard);

// ── GET /dashboard - Admin Dashboard Stats ──
router.get('/dashboard', async (_req: Request, res: Response) => {
  try {
    const [usersSnapshot, ordersSnapshot, productsSnapshot, paymentsSnapshot] = await Promise.all([
      db.collection('users').count().get(),
      db.collection('orders').count().get(),
      db.collection('products').count().get(),
      db.collection('payments').count().get(),
    ]);

    // Recent activities
    const recentAuditLogs = await db.collection('audit_logs')
      .orderBy('timestamp', 'desc')
      .limit(20)
      .get();

    const recentLogs = recentAuditLogs.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: {
        stats: {
          totalUsers: usersSnapshot.data().count,
          totalOrders: ordersSnapshot.data().count,
          totalProducts: productsSnapshot.data().count,
          totalPayments: paymentsSnapshot.data().count,
        },
        recentActivity: recentLogs,
      },
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to load dashboard' });
  }
});

// ── GET /config - System Configuration ──
router.get('/config', async (_req: Request, res: Response) => {
  try {
    const configDoc = await db.collection('system_config').doc('app_settings').get();
    if (!configDoc.exists) {
      return res.status(HTTP_STATUS.NOT_FOUND).json({ success: false, message: 'Config not found' });
    }
    res.status(HTTP_STATUS.OK).json({ success: true, data: { id: configDoc.id, ...configDoc.data() } });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to load config' });
  }
});

// ── PUT /config - Update System Configuration ──
router.put('/config', async (req: Request, res: Response) => {
  try {
    const updates = req.body;
    await db.collection('system_config').doc('app_settings').update({
      ...updates,
      updatedAt: new Date().toISOString(),
    });
    res.status(HTTP_STATUS.OK).json({ success: true, message: 'Config updated' });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to update config' });
  }
});

// ── GET /users - List All Users ──
router.get('/users', async (req: Request, res: Response) => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;
    const snapshot = await db.collection('users').orderBy('createdAt', 'desc').offset(offset).limit(limit).get();
    const users = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.status(HTTP_STATUS.OK).json({ success: true, data: users, count: users.length });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to load users' });
  }
});

// ── PUT /users/:id/role - Update User Role ──
router.put('/users/:id/role', async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { role } = req.body;
    if (!role) {
      return res.status(HTTP_STATUS.BAD_REQUEST).json({ success: false, message: 'Role is required' });
    }
    await db.collection('users').doc(id).update({ role, updatedAt: new Date().toISOString() });
    res.status(HTTP_STATUS.OK).json({ success: true, message: 'User role updated' });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to update role' });
  }
});

// ── PUT /users/:id/ban - Toggle User Ban ──
router.put('/users/:id/ban', async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { banned } = req.body;
    await db.collection('users').doc(id).update({
      banned: banned,
      bannedAt: banned ? new Date().toISOString() : null,
      updatedAt: new Date().toISOString(),
    });
    res.status(HTTP_STATUS.OK).json({ success: true, message: banned ? 'User banned' : 'User unbanned' });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to toggle ban' });
  }
});

// ── GET /audit-logs - Fetch Audit Logs ──
router.get('/audit-logs', async (req: Request, res: Response) => {
  try {
    const limit = parseInt(req.query.limit as string) || 100;
    const snapshot = await db.collection('audit_logs').orderBy('timestamp', 'desc').limit(limit).get();
    const logs = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.status(HTTP_STATUS.OK).json({ success: true, data: logs, count: logs.length });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to load audit logs' });
  }
});

// ── GET /analytics/summary - Business Analytics Summary ──
router.get('/analytics/summary', async (_req: Request, res: Response) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const [recentOrders, recentPayments, topProducts] = await Promise.all([
      db.collection('orders').where('createdAt', '>=', thirtyDaysAgo.toISOString()).get(),
      db.collection('payments').where('createdAt', '>=', thirtyDaysAgo.toISOString()).get(),
      db.collection('orders').orderBy('total', 'desc').limit(5).get(),
    ]);

    const totalRevenue = recentPayments.docs.reduce((sum, doc) => {
      const data = doc.data();
      return sum + (data.amount || 0);
    }, 0);

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: {
        period: '30days',
        orderCount: recentOrders.docs.length,
        paymentCount: recentPayments.docs.length,
        totalRevenue,
        topProducts: topProducts.docs.map(doc => ({ id: doc.id, ...doc.data() })),
      },
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to load analytics' });
  }
});

// ── GET /analytics/revenue - Revenue Over Time ──
router.get('/analytics/revenue', async (_req: Request, res: Response) => {
  try {
    const payments = await db.collection('payments').orderBy('createdAt', 'desc').get();
    
    // Group by month
    const monthlyRevenue: Record<string, number> = {};
    payments.docs.forEach(doc => {
      const data = doc.data();
      const date = data.createdAt?.substring(0, 7) || 'unknown';
      monthlyRevenue[date] = (monthlyRevenue[date] || 0) + (data.amount || 0);
    });

    res.status(HTTP_STATUS.OK).json({
      success: true,
      data: Object.entries(monthlyRevenue).map(([month, revenue]) => ({ month, revenue })),
    });
  } catch (error) {
    res.status(HTTP_STATUS.INTERNAL_ERROR).json({ success: false, message: 'Failed to load revenue data' });
  }
});

export default router;