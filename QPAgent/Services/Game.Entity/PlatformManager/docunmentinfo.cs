using System;
using System.Collections.Generic;

namespace Game.Entity.PlatformManager
{
    [Serializable]
    public partial class docunmentinfo
    {
        public const string Tablename = "docunmentinfo";
        public const string _docid = "docid";
        public const string _docuserid = "docuserid";
        public const string _docowner = "docowner";
        public const string _docname = "docname";
        public const string _doctype = "doctype";
        public const string _docsize = "docsize";
        public const string _docpath = "docpath";
        public const string _docstate = "docstate";
        public const string _doctime = "doctime";
        public const string _docnote = "docnote";

        private int m_docid;
        private int m_docuserid;
        private string m_docowner;
        private string m_docname;
        private string m_doctype;
        private long m_docsize;
        private string m_docpath;
        private bool m_docstate;
        private DateTime m_doctime;
        private string m_docnote;

        public docunmentinfo()
        {
            m_docid = 0;
            m_docuserid = 0;
            m_docowner = "";
            m_docname = "";
            m_doctype = "";
            m_docsize = 0;
            m_docpath = "";
            m_docstate = false;
            m_doctime = DateTime.Now;
            m_docnote = "";
        }

        public int docid
        {
            get { return m_docid; }
            set { m_docid = value; }
        }
        public int docuserid
        {
            get { return m_docuserid; }
            set { m_docuserid = value; }
        }
        public string docowner
        {
            get { return m_docowner; }
            set { m_docowner = value; }
        }
        public string docname
        {
            get { return m_docname; }
            set { m_docname = value; }
        }
        public string doctype
        {
            get { return m_doctype; }
            set { m_doctype = value; }
        }
        public long docsize
        {
            get { return m_docsize; }
            set { m_docsize = value; }
        }
        public string docpath
        {
            get { return m_docpath; }
            set { m_docpath = value; }
        }
        public bool docstate
        {
            get { return m_docstate; }
            set { m_docstate = value; }
        }
        public DateTime doctime
        {
            get { return m_doctime; }
            set { m_doctime = value; }
        }
        public string docnote
        {
            get { return m_docnote; }
            set { m_docnote = value; }
        }
    }
}
