// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2013-2016 Birdie Developers (http://birdieapp.github.io)
 *
 * This software is licensed under the GNU General Public License
 * (version 3 or later). See the COPYING file in this distribution.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this software; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Ivo Nunes <ivoavnunes@gmail.com>
 *              Vasco Nunes <vascomfnunes@gmail.com>
 *              Nathan Dyer <mail@nathandyer.me>
 */

namespace Birdie {

    namespace Option {
        private static bool DEBUG = false;
        private static bool START_HIDDEN = false;
    }

    public static int main (string[] args) {
        X.init_threads ();

        var context = new OptionContext ("Birdie");
        context.add_main_entries (Birdie.app_options, "birdie");
        context.add_group (Gtk.get_option_group(true));

        try {
            context.parse (ref args);
        } catch (Error e) {
            warning (e.message);
        }

        Gtk.init (ref args);
        var app = new Birdie ();

        return app.run (args);
    }
}
