import 'package:flutter_app/modules/common/base/base_controller.dart';
import 'package:flutter_app/pp_kits/pp_kits.dart';

class LanguageController extends BaseController {
  /* #region 状态属性 */

  /* #endregion */

  /* #region 私有属性 */
  /* #endregion */

  /* #region 公开属性 */

  /* #endregion */

  /* #region 基类方法 */
  @override
  void onInit() {
    Logger.trace('对象初始化');
    super.onInit();
  }

  @override
  void onReady() {
    Logger.trace('加载就绪');
    super.onReady();
  }

  @override
  void onClose() {
    Logger.trace('对象销毁');
    super.onClose();
  }

  @override
  void initData() {
    super.initData();
    Logger.trace('初始化数据');
  }

  @override
  void startListener() {
    Logger.trace('开启监听');
    super.startListener();
  }

  @override
  void reloadData() async {}
  /* #endregion */

  /* #region 自定义方法 */

  /* #endregion */

  /* #region 自定义事件 */

  /* #endregion */
}
