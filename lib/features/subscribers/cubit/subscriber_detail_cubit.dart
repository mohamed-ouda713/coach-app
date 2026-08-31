// lib/features/subscribers/cubit/subscriber_detail_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import 'subscriber_cubit.dart';
import 'subscriber_detail_state.dart';

/// Cubit مخصص لحالة "عميل واحدة" (شاشة الملف الشخصي وشاشة التعديل).
///
/// مقصود إنه يكون منفصل عن [SubscriberCubit] رغم إنه بيعتمد عليه —
/// [SubscriberCubit] عنده state واحد مشترك لقائمة العملاء بالكامل
/// (تستخدمه SubscribersListScreen)، فلو خلينا جلب عميل واحدة يصدر
/// state من نفس الـ Cubit، كان رح يتضارب مع state القائمة لأنه نفس
/// الـ instance مشترك عالمياً. هيك، كل شاشة تفاصيل بتاخد نسخة محلية
/// من هاد الـ Cubit (عبر BlocProvider محلي) وعندها دورة حياة/state
/// خاصة فيها، من غير ما تلمس state القائمة.
class SubscriberDetailCubit extends Cubit<SubscriberDetailState> {
  SubscriberDetailCubit(this._subscriberCubit)
    : super(const SubscriberDetailInitial());

  final SubscriberCubit _subscriberCubit;

  /// بترسم فورًا من القائمة المحمّلة بالذاكرة لو العميل موجودة فيها،
  /// وبعدين بتجدّد من السيرفر بالخلفية. قبل هيك كانت كل مرة تنفتح فيها
  /// الشاشة تعرض spinner وتستنى رحلة شبكة كاملة لبيانات معروضة أصلاً
  /// بالقائمة يلي إجت منها.
  Future<void> load(String id) async {
    final cached = _subscriberCubit.findLoadedSubscriber(id);
    if (cached != null) {
      emit(SubscriberDetailLoaded(cached));
    } else if (state is! SubscriberDetailLoaded) {
      emit(const SubscriberDetailLoading());
    }

    try {
      final subscriber = await _subscriberCubit.fetchSubscriberById(id);
      if (!isClosed) emit(SubscriberDetailLoaded(subscriber));
    } catch (e) {
      // fetchSubscriberById بترمي AppException برسالة مُترجمة أصلاً —
      // ExceptionMapper بترجعها زي ما هي (fast path)، وبتضل شغالة
      // بأمان لو صار أي استثناء آخر غير متوقع.
      //
      // لو في نسخة معروضة أصلاً (من الكاش أو من تحميل سابق)، ما منمسح
      // الشاشة بخطأ — التحديث بالخلفية فشل بس البيانات لسا صالحة.
      if (isClosed || state is SubscriberDetailLoaded) return;
      emit(SubscriberDetailError(ExceptionMapper.mapToMessage(e)));
    }
  }
}
