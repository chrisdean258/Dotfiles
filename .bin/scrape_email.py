#!/usr/bin/env python3

import imaplib
import email
import os
import getpass
# import sys
# import glob


class Email:
    def __init__(self, body, attachments=()):
        self.__dict__.update(locals())


class Scraper:
    def __init__(self, user=None, imap_url="imap.google.com", imap_port=993):
        password = os.environ.get("email_") or getpass.getpass()
        self.con = imaplib.IMAP4_SSL(imap_url, imap_port)
        self.con.login(user, password)
        self.selected = False

    def select(self, mailbox):
        self.con.select(mailbox)
        self.selected = True

    def search_subject(self, query):
        self.con.select('INBOX')
        typ, data = self.con.search(None, "Subject", '"{}"'.format(query))
        if not typ:
            pass  # There should be error handling here

        return [self._get_email(num) for num in data[0].split()]

    def _get_email(self, num):
        typ, data = self.con.fetch(num, '(RFC822)')
        if not typ:
            pass  # There should be error handling here
        mail = email.message_from_bytes(data[0][1])
        body = self._get_body(mail).decode('utf-8').replace("\r\n", "\n")
        attachments = self._get_attachments(mail)
        return Email(body, attachments)

    def _get_body(self, msg):
        if msg.is_multipart():
            return self._get_body(msg.get_payload(0))
        else:
            return msg.get_payload(None, True)

    def _get_attachments(self, msg):
        attachments = []
        for part in msg.walk():
            if part.get_content_maintype() == 'multipart':
                continue
            if part.get('Content-Disposition') is None:
                continue
            fileName = part.get_filename()
            if fileName:
                attachments.append((fileName, part.get_payload(decode=True)))
        return attachments
