// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2013 Birdie Developers (http://launchpad.net/birdie)
 *
 * This software is licensed under the GNU General Public License
 * (version 3 or later). See the COPYING file in this distribution.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this software; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Ivo Nunes <ivo@elementaryos.org>
 *              Vasco Nunes <vascomfnunes@gmail.com>
 */

namespace Birdie.Utils {

    string highlight_all (owned string text) {
        text = highlight_urls (text);
        text = highlight_hashtags (text);
        text = highlight_users (text);
        text = text.replace ("&", "&amp;");
        return text;
    }

    string highlight_hashtags (owned string text) {
        Regex urls;

        try {
            urls = new Regex("([#][[:alpha:]0-9_]+)");
            text = urls.replace(text, -1, 0,
                "<span underline='none'><a href='birdie://search/\\0'>\\0</a></span>");
        } catch (RegexError e) {
            warning ("regex error: %s", e.message);
        }
        return text;
    }

    string highlight_users (owned string text) {
        Regex urls;

        try {
            urls = new Regex("([@][[:alpha:]0-9_]+)");
            text = urls.replace(text, -1, 0,
                "<span underline='none'><a href='birdie://user/\\0'>\\0</a></span>");
        } catch (RegexError e) {
            warning ("regex error: %s", e.message);
        }
        return text;
    }

    string highlight_urls (owned string text) {
        Regex urls;

        try {
            urls = new Regex("((http|https|ftp)://(([[:alpha:]0-9?=_#\\-&~+=,%$!]|[/.]|[~])*)\\b)");
            text = urls.replace(text, -1, 0,
                "<span underline='none'><a href='\\0'>\\0</a></span>");
            if ("</a></span>/" in text)
                text = text.replace ("</a></span>/", "/</a></span>");
        } catch (RegexError e) {
            warning ("regex error: %s", e.message);
        }
        return text;
    }

    string escape_amp (string txt) {
        string to_escape = txt;
        if ("&" in to_escape)
            to_escape = to_escape.replace ("&", "&amp;");
        return to_escape;
    }

    string remove_html_tags (string input) {
        try {
            string output = input;
            
            // Count the number of < and > characters.
            unichar c;
            uint64 less_than = 0;
            uint64 greater_than = 0;
            for (int i = 0; output.get_next_char (ref i, out c);) {
                if (c == '<')
                    less_than++;
                else if (c == '>')
                    greater_than++;
            }
            
            if (less_than == greater_than + 1) {
                output += ">"; // Append an extra > so our regex works.
                greater_than++;
            }
            
            if (less_than != greater_than)
                return input; // Invalid HTML.
            
            // Removes script tags and everything between them.
            // Based on regex here: http://stackoverflow.com/questions/116403/im-looking-for-a-regular-expression-to-remove-a-given-xhtml-tag-from-a-string
            Regex script = new Regex("<script[^>]*?>[\\s\\S]*?<\\/script>", RegexCompileFlags.CASELESS);
            output = script.replace(output, -1, 0, "");
            
            // Removes style tags and everything between them.
            // Based on regex above.
            Regex style = new Regex("<style[^>]*?>[\\s\\S]*?<\\/style>", RegexCompileFlags.CASELESS);
            output = style.replace(output, -1, 0, "");
            
            // Removes remaining tags. Based on this regex:
            // http://osherove.com/blog/2003/5/13/strip-html-tags-from-a-string-using-regular-expressions.html
            Regex tags = new Regex("<(.|\n)*?>", RegexCompileFlags.CASELESS);
            return tags.replace(output, -1, 0, "");
        } catch (Error e) {
            debug("Error stripping HTML tags: %s", e.message);
        }
        
        return input;
    }

    string escape_markup (string text) {
        return GLib.Markup.escape_text (text);
    }

    string unescape_entities (string text) {
        string escaped_text = text.replace ("&amp;", "&");
        return escaped_text;
    }
}
