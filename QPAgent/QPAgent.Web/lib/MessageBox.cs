using System;

namespace Game.Web
{
    [Serializable]
    public class MessageBox
    {
        #region 构造函数
        public MessageBox(String statusCode, String message, bool IsClosed, String relid)
        {
            _statusCode = statusCode;
            _message = message;
            _navTabId = relid;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = relid;
            _closeCurrent = IsClosed;
            _confirmMsg = String.Empty;
        }
        public MessageBox(String statusCode, String message, bool IsClosed, String navTabId, String relid)
        {
            _statusCode = statusCode;
            _message = message;
            _navTabId = navTabId;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = relid;
            _closeCurrent = IsClosed;
            _confirmMsg = String.Empty;
        }

        public MessageBox(String statusCode, String message, bool IsClosed)
        {
            _statusCode = statusCode;
            _message = message;
            _navTabId = String.Empty;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = String.Empty;
            _closeCurrent = IsClosed;
            _confirmMsg = String.Empty;
        }

        public MessageBox(String statusCode, bool IsClosed, String relid)
        {
            _statusCode = statusCode;
            _message = String.Empty;
            _navTabId = relid;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = relid;
            _closeCurrent = IsClosed;
            _confirmMsg = String.Empty;
        }


        public MessageBox(bool IsClosed, String relid)
        {
            _statusCode = "200";
            _message = String.Empty;
            _navTabId = relid;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = relid;
            _closeCurrent = IsClosed;
            _confirmMsg = String.Empty;
        }


        public MessageBox(String relid)
        {
            _statusCode = "200";
            _message = String.Empty;
            _navTabId = relid;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = relid;
            _closeCurrent = true;
            _confirmMsg = String.Empty;
        }


        public MessageBox()
        {
            _statusCode = "200";
            _message = String.Empty;
            _navTabId = String.Empty;
            _forwardUrl = String.Empty;
            _callbackType = String.Empty;
            _rel = String.Empty;
            _closeCurrent = false;
            _confirmMsg = String.Empty;
        }

        public MessageBox(string p, int result, bool p_2, string p_3)
        {
            // TODO: Complete member initialization
            this.p = p;
            this.result = result;
            this.p_2 = p_2;
            this.p_3 = p_3;
        }


        #endregion
        #region 私有变量
        private String _statusCode;
        private String _message;
        private String _navTabId;
        private String _forwardUrl;
        private String _callbackType;
        private String _rel;
        private bool _closeCurrent;
        private String _confirmMsg;
        private string p;
        private int result;
        private bool p_2;
        private string p_3;
        #endregion
        #region 公共方法
        public String statusCode
        {
            get { return (_statusCode); }
            set { _statusCode = value; }
        }
        public String message
        {
            get
            {
                if (_statusCode == "200")
                {
                    return (String.IsNullOrEmpty(_message) ? "操作成功" : _message);
                }
                else if (_statusCode == "301")
                {
                    return (String.IsNullOrEmpty(_message) ? "登录超时，请重新登录!" : _message);
                }
                else
                {
                    return (String.IsNullOrEmpty(_message) ? "操作失败" : _message);
                }
            }
            set { _message = value; }
        }
        public String navTabId
        {
            get { return (_navTabId); }
            set { _navTabId = value; }
        }
        public String forwardUrl
        {
            get { return (_forwardUrl); }
            set { _forwardUrl = value; }
        }
        public String callbackType
        {
            get
            {
                if (_closeCurrent)
                {
                    return ("closeCurrent");
                }
                else
                {
                    return (_callbackType);
                }
            }
            set { _callbackType = value; }
        }
        public String rel
        {
            get { return (_rel); }
            set { _rel = value; }
        }
        public String confirmMsg
        {
            get { return (_confirmMsg); }
            set { _confirmMsg = value; }
        }
        #endregion
    }
}