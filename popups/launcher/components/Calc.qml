import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.config

import core

IComponent {
    id: root

    property int cursorPosition: SelectionState.cursorPosition

    name: "Calculator"
    preview: Component {
        Icon {
            text: ""
        }
    }

    onInputChanged: {
        MathCalc.reset_result();
    }

    process: function () {
        MathCalc.query(input);
        const valid = MathCalc.result && MathCalc.result.length > 0;
        const answer = MathCalc.result ? MathCalc.result
        // 1. Calculus & Summations (Case insensitive)
        .replace(/\bint(?:egral)?\b/gi, "∫").replace(/\bsum\b/gi, "∑")

        // 2. Constants & Symbols (Case insensitive)
        .replace(/\bpi\b/gi, "π").replace(/\btau\b/gi, "τ").replace(/\binf(?:inity)?\b/gi, "∞").replace(/\bdeg\b/gi, "°")

        // 3. Roots & Exponentials (Case insensitive)
        .replace(/\bsqrt\b/gi, "√").replace(/\bcbrt\b/gi, "∛")

        // 4. Rounding & Absolute Value (Case insensitive)
        .replace(/\bceil\(([^\)]+)\)/gi, "⌈$1⌉").replace(/\bfloor\(([^\)]+)\)/gi, "⌊$1⌋").replace(/\bround\b/gi, " ≈ ")

        // 5. Comparison & Equality
        .replace(/\s*<=\s*/g, " ≤ ").replace(/\s*>=\s*/g, " ≥ ").replace(/\s*!=\s*/g, " ≠ ").replace(/\s*==\s*/g, " = ")

        // 6. Exponents to Unicode Superscripts FIRST (Case insensitive for ^n, ^x, ^y)
        .replace(/\^0/g, "⁰").replace(/\^1/g, "¹").replace(/\^2/g, "²").replace(/\^3/g, "³").replace(/\^4/g, "⁴").replace(/\^5/g, "⁵").replace(/\^6/g, "⁶").replace(/\^7/g, "⁷").replace(/\^8/g, "⁸").replace(/\^9/g, "⁹").replace(/\^\+/g, "⁺").replace(/\^-/g, "⁻").replace(/\^n/gi, "ⁿ").replace(/\^x/gi, "ˣ").replace(/\^y/gi, "ʸ")

        // 7. Kalk Number Bases
        .replace(/_0/g, "₀").replace(/_10/g, "₁₀").replace(/_16/g, "₁₆").replace(/_1/g, "₁").replace(/_2/g, "₂").replace(/_3/g, "₃").replace(/_4/g, "₄").replace(/_5/g, "₅").replace(/_6/g, "₆").replace(/_7/g, "₇").replace(/_8/g, "₈").replace(/_9/g, "₉")

        // 8. Arithmetic Operators
        .replace(/\s*\*\s*/g, " × ").replace(/\s*\/\s*/g, " ÷ ").replace(/\s*-\s*/g, " − ").replace(/\s*\+\s*/g, " + ") : "";
        return {
            valid,
            priority: valid,
            answer,
            predictiveCompletion: valid ? ' = ' + answer : ''
        };
    }
    exec: function () {
        Clip.copy(answer);
        MathCalc.reset_ctx();
    }

    IInnerComponent {
        RowLayout {
            spacing: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height

            Item {
                Layout.fillWidth: true
                IText {
                    anchors.centerIn: parent
                    elide: cursorPosition > input.length / 2 ? Text.ElideLeft : Text.ElideRight
                    width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                    clip: true
                    renderType: Text.CurveRendering
                    visible: valid
                    text: input
                    // 1. Calculus & Summations (Case insensitive)
                    .replace(/\bint(?:egral)?\b/gi, "∫").replace(/\bsum\b/gi, "∑")

                    // 2. Constants & Symbols (Case insensitive)
                    .replace(/\bpi\b/gi, "π").replace(/\btau\b/gi, "τ").replace(/\binf(?:inity)?\b/gi, "∞").replace(/\bdeg\b/gi, "°")

                    // 3. Roots & Exponentials (Case insensitive)
                    .replace(/\bsqrt\b/gi, "√").replace(/\bcbrt\b/gi, "∛")

                    // 4. Rounding & Absolute Value (Case insensitive)
                    .replace(/\bceil\(([^\)]+)\)/gi, "⌈$1⌉").replace(/\bfloor\(([^\)]+)\)/gi, "⌊$1⌋").replace(/\bround\b/gi, " ≈ ")

                    // 5. Comparison & Equality
                    .replace(/\s*<=\s*/g, " ≤ ").replace(/\s*>=\s*/g, " ≥ ").replace(/\s*!=\s*/g, " ≠ ").replace(/\s*==\s*/g, " = ")

                    // 6. Exponents to Unicode Superscripts FIRST (Case insensitive for ^n, ^x, ^y)
                    .replace(/\^0/g, "⁰").replace(/\^1/g, "¹").replace(/\^2/g, "²").replace(/\^3/g, "³").replace(/\^4/g, "⁴").replace(/\^5/g, "⁵").replace(/\^6/g, "⁶").replace(/\^7/g, "⁷").replace(/\^8/g, "⁸").replace(/\^9/g, "⁹").replace(/\^\+/g, "⁺").replace(/\^-/g, "⁻").replace(/\^n/gi, "ⁿ").replace(/\^x/gi, "ˣ").replace(/\^y/gi, "ʸ")

                    // 7. Kalk Number Bases
                    .replace(/_0/g, "₀").replace(/_10/g, "₁₀").replace(/_16/g, "₁₆").replace(/_1/g, "₁").replace(/_2/g, "₂").replace(/_3/g, "₃").replace(/_4/g, "₄").replace(/_5/g, "₅").replace(/_6/g, "₆").replace(/_7/g, "₇").replace(/_8/g, "₈").replace(/_9/g, "₉")

                    // 8. Arithmetic Operators
                    .replace(/\s*\*\s*/g, " × ").replace(/\s*\/\s*/g, " ÷ ").replace(/\s*-\s*/g, " − ").replace(/\s*\+\s*/g, " + ")
                    font {
                        pixelSize: Launcher.widgetFontSize
                        bold: root.isSelectedPriority()
                    }
                }
            }

            IText {
                visible: valid
                text: "→"
                font.pixelSize: Launcher.widgetFontSize
                font.bold: root.isSelectedPriority()
            }

            Item {
                Layout.fillWidth: true
                IText {
                    animate: true
                    anchors.centerIn: parent
                    width: Math.min(implicitWidth, parent.width - Launcher.innerMargin * 2)
                    renderType: Text.CurveRendering
                    visible: valid
                    text: valid ? answer : ''
                    font {
                        pixelSize: Launcher.widgetFontSize
                        bold: root.isSelectedPriority()
                    }
                }
            }
        }
    }
}
